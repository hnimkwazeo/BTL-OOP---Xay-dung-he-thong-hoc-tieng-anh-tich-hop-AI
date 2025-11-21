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
    public ChatbotService(ChatMessageRepository chatMessageRepository, UserRepository userRepository, RestClient.Builder restClientBuilder) {
        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
        this.restClient = restClientBuilder.build();
    }

    @Data
    @NoArgsConstructor
    private static class PythonAiResponse {
        private String assistantResponse;
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
            Map<String, Object> payload = new HashMap<>();
            payload.put("message", request.getMessage()); // Gửi key "message"

            PythonAiResponse response = restClient.post().uri(nlpApiUrl).contentType(MediaType.APPLICATION_JSON).body(payload).retrieve().body(PythonAiResponse.class);
            
            if (response != null) assistantResponseText = response.getAssistantResponse() != null ? response.getAssistantResponse() : response.getText();
        } catch (Exception e) {
            logger.error("AI Error: ", e);
        }

        chatMessageRepository.save(new ChatMessage(null, currentUser, conversationId, "user", request.getMessage(), Instant.now()));
        chatMessageRepository.save(new ChatMessage(null, currentUser, conversationId, "assistant", assistantResponseText, Instant.now()));

        return new ChatResponseDTO(assistantResponseText, conversationId);
    }
}