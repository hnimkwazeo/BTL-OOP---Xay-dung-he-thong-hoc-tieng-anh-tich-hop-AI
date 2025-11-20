package com.fourstars.FourStars.service;

import com.fourstars.FourStars.domain.ChatMessage;
import com.fourstars.FourStars.domain.User;
import com.fourstars.FourStars.domain.request.chatbot.ChatRequestDTO;
import com.fourstars.FourStars.domain.response.chatbot.ChatResponseDTO;
import com.fourstars.FourStars.repository.ChatMessageRepository;
import com.fourstars.FourStars.repository.UserRepository;
import com.fourstars.FourStars.util.SecurityUtil;
import com.fourstars.FourStars.util.error.ResourceNotFoundException;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ChatbotService {

    private static final Logger logger = LoggerFactory.getLogger(ChatbotService.class);
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final RestClient restClient; 

    @Value("${NLP_API_URL:http://localhost:8000/api/chat}")
    private String nlpApiUrl;

    @Autowired
    public ChatbotService(ChatMessageRepository chatMessageRepository,
                          UserRepository userRepository,
                          RestClient.Builder restClientBuilder) { 
        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
        this.restClient = restClientBuilder.build();
    }

    @Data
    @NoArgsConstructor
    private static class PythonAiResponse {
        private String assistantResponse;
        private String text;
        private String new_response;
        private String error;
    }

    public ChatResponseDTO getChatbotResponse(ChatRequestDTO request) {
        // 1. Lấy thông tin user
        User currentUser = SecurityUtil.getCurrentUserLogin()
                .flatMap(userRepository::findByEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not authenticated"));

        // 2. Xử lý Conversation ID
        String conversationId;
        if (request.getConversationId() != null && !request.getConversationId().isBlank()) {
            conversationId = request.getConversationId();
        } else {
            Optional<ChatMessage> latestMessage = chatMessageRepository
                    .findFirstByUserOrderByCreatedAtDesc(currentUser);
            conversationId = latestMessage.map(ChatMessage::getConversationId).orElse(UUID.randomUUID().toString());
        }

        // 3. Chuẩn bị dữ liệu gửi sang Python
        Map<String, Object> payload = new HashMap<>();
        payload.put("message", request.getMessage());
        logger.info("Dang goi sang AI Service tai URL: {}", nlpApiUrl);

        String assistantResponseText = "Xin lỗi, tôi đang gặp sự cố kết nối.";

        try {
            // 4. GỌI SANG PYTHON SERVICE 
            PythonAiResponse response = restClient.post()
                    .uri(nlpApiUrl)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(payload)
                    .retrieve()
                    .body(PythonAiResponse.class);

            if (response != null) {
                if (response.getError() != null) {
                    logger.error("AI Service bao loi: {}", response.getError());
                    assistantResponseText = "Lỗi từ AI: " + response.getError();
                } else {
                    assistantResponseText = response.getAssistantResponse() != null
                            ? response.getAssistantResponse()
                            : response.getText();
                }
            }

        } catch (Exception e) {
            logger.error("Loi khi goi AI Service: ", e);
            assistantResponseText = "Hệ thống AI đang bảo trì hoặc quá tải. (" + e.getMessage() + ")";
        }

        // 5. Lưu tin nhắn vào Database (Giữ nguyên logic cũ)
        ChatMessage userMessage = new ChatMessage(null, currentUser, conversationId, "user", request.getMessage(), Instant.now());
        chatMessageRepository.save(userMessage);

        ChatMessage assistantMessage = new ChatMessage(null, currentUser, conversationId, "assistant", assistantResponseText, Instant.now());
        chatMessageRepository.save(assistantMessage);

        return new ChatResponseDTO(assistantResponseText, conversationId);
    }
}