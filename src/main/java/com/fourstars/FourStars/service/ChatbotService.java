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
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate; // Dùng RestTemplate

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
    
    // Chúng ta dùng RestTemplate mới trực tiếp, không cần Inject Bean cũ
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${NLP_API_URL}")
    private String nlpApiUrl;

    @Autowired
    public ChatbotService(ChatMessageRepository chatMessageRepository, UserRepository userRepository) {
        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
    }

    @Data
    @NoArgsConstructor
    private static class PythonAiResponse {
        private String text;
        private String error;
    }

    public ChatResponseDTO getChatbotResponse(ChatRequestDTO request) {
        User currentUser = SecurityUtil.getCurrentUserLogin().flatMap(userRepository::findByEmail).orElseThrow(() -> new ResourceNotFoundException("User not authenticated"));
        
        String conversationId = (request.getConversationId() != null && !request.getConversationId().isBlank()) 
                ? request.getConversationId() 
                : chatMessageRepository.findFirstByUserOrderByCreatedAtDesc(currentUser).map(ChatMessage::getConversationId).orElse(UUID.randomUUID().toString());

        String assistantResponseText = "Lỗi kết nối AI.";
        try {
            String chatEndpoint = nlpApiUrl + "/api/chat";
            
            // --- SỬA: Dùng RestTemplate để gửi JSON chuẩn xác ---
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            // Tạo Map dữ liệu (RestTemplate tự động chuyển Map thành JSON chuẩn)
            Map<String, String> payload = new HashMap<>();
            payload.put("message", request.getMessage());
            
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(payload, headers);
            
            logger.info("Sending to Python (RestTemplate): {}", chatEndpoint);
            
            // Gửi Request
            PythonAiResponse response = restTemplate.postForObject(chatEndpoint, entity, PythonAiResponse.class);
            
            if (response != null) {
                assistantResponseText = response.getText() != null ? response.getText() : "AI không trả lời.";
            }
        } catch (Exception e) {
            logger.error("AI Error: ", e);
            assistantResponseText = "Lỗi xử lý AI: " + e.getMessage();
        }

        chatMessageRepository.save(new ChatMessage(null, currentUser, conversationId, "user", request.getMessage(), Instant.now()));
        chatMessageRepository.save(new ChatMessage(null, currentUser, conversationId, "assistant", assistantResponseText, Instant.now()));

        return new ChatResponseDTO(assistantResponseText, conversationId);
    }
}