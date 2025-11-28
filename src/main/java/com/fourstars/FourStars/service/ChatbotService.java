package com.fourstars.FourStars.service;

import com.fourstars.FourStars.domain.ChatMessage;
import com.fourstars.FourStars.domain.User;
import com.fourstars.FourStars.domain.request.chatbot.ChatRequestDTO;
import com.fourstars.FourStars.domain.request.chatbot.ExplainRequestDTO;
import com.fourstars.FourStars.domain.response.chatbot.ChatResponseDTO;
import com.fourstars.FourStars.repository.ChatMessageRepository;
import com.fourstars.FourStars.repository.UserRepository;
import com.fourstars.FourStars.util.SecurityUtil;
import com.fourstars.FourStars.util.error.ResourceNotFoundException;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor // Tự động tạo constructor injection
public class ChatbotService {

    private static final Logger logger = LoggerFactory.getLogger(ChatbotService.class);
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;

    // Khởi tạo RestTemplate trực tiếp
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${NLP_API_URL}")
    private String nlpApiUrl;

    // Class nội bộ để map response từ Python
    @Data
    @NoArgsConstructor
    private static class PythonAiResponse {
        private String text;
        private String error;
    }

    // ========================================================================
    // 1. LOGIC CHAT THƯỜNG (Giữ nguyên logic cũ của bạn)
    // ========================================================================
    public ChatResponseDTO getChatbotResponse(ChatRequestDTO request) {
        User currentUser = getCurrentUserEntity();

        // Lấy hoặc tạo Conversation ID
        String conversationId = (request.getConversationId() != null && !request.getConversationId().isBlank())
                ? request.getConversationId()
                : getLatestOrNewConversationId(currentUser);

        // Gọi AI
        String assistantResponseText = callPythonAI(request.getMessage());

        // Lưu User message
        saveMessageToDB(currentUser, conversationId, "user", request.getMessage());
        // Lưu AI message
        saveMessageToDB(currentUser, conversationId, "assistant", assistantResponseText); // Role 'assistant' khớp logic cũ

        return new ChatResponseDTO(assistantResponseText, conversationId);
    }

    // ========================================================================
    // 2. LOGIC GIẢI THÍCH BÀI TẬP (MỚI THÊM VÀO)
    // ========================================================================
    public String generateExplanation(ExplainRequestDTO req) { // Đổi void thành String
        User currentUser = getCurrentUserEntity();
        String conversationId = getLatestOrNewConversationId(currentUser);

        // 1. Tạo Prompt
        String prompt = buildSmartPrompt(req);

        // 2. Lưu câu hỏi User
        saveMessageToDB(currentUser, conversationId, "user", prompt);

        // 3. Gọi AI
        String aiResponse = callPythonAI(prompt);

        // 4. Lưu câu trả lời AI
        saveMessageToDB(currentUser, conversationId, "assistant", aiResponse);

        // --- RETURN KẾT QUẢ ---
        return aiResponse;
    }

    // ========================================================================
    // 3. PRIVATE HELPER METHODS (Dùng chung)
    // ========================================================================

    // Hàm gọi sang Python Service
    private String callPythonAI(String message) {
        try {
            String chatEndpoint = nlpApiUrl + "/api/chat";
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> payload = new HashMap<>();
            payload.put("message", message);

            HttpEntity<Map<String, String>> entity = new HttpEntity<>(payload, headers);

            logger.info("Sending to Python AI: {}", chatEndpoint);

            PythonAiResponse response = restTemplate.postForObject(chatEndpoint, entity, PythonAiResponse.class);

            if (response != null && response.getText() != null) {
                return response.getText();
            }
            return "AI không phản hồi nội dung.";
        } catch (Exception e) {
            logger.error("AI Connection Error: ", e);
            return "Xin lỗi, tôi đang gặp sự cố kết nối với máy chủ AI. Vui lòng thử lại sau.";
        }
    }

    // Hàm lưu tin nhắn vào DB
    private void saveMessageToDB(User user, String conversationId, String role, String content) {
        ChatMessage msg = new ChatMessage();
        msg.setUser(user);
        msg.setConversationId(conversationId);
        msg.setRole(role);
        msg.setContent(content);
        msg.setCreatedAt(Instant.now()); // Dùng Instant thay vì LocalDateTime
        chatMessageRepository.save(msg);
    }

    // Hàm lấy User hiện tại từ SecurityUtil
    private User getCurrentUserEntity() {
        return SecurityUtil.getCurrentUserLogin()
                .flatMap(userRepository::findByEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not authenticated or not found"));
    }

    // Hàm lấy ConversationID mới nhất hoặc tạo mới
    private String getLatestOrNewConversationId(User user) {
        return chatMessageRepository.findFirstByUserOrderByCreatedAtDesc(user)
                .map(ChatMessage::getConversationId)
                .orElse(UUID.randomUUID().toString());
    }

    // Hàm tạo Prompt cho tính năng giải thích
    private String buildSmartPrompt(ExplainRequestDTO req) {
        StringBuilder sb = new StringBuilder();

        boolean isCorrect = req.getUserAnswer() != null
                && req.getUserAnswer().equalsIgnoreCase(req.getCorrectAnswer());

        sb.append("Tôi đang làm bài tập tiếng Anh và cần sự trợ giúp.\n");
        sb.append("Câu hỏi: ").append(req.getQuestionContent()).append("\n");

        if (req.getUserAnswer() != null) {
            sb.append("Tôi chọn: ").append(req.getUserAnswer()).append("\n");
        }
        sb.append("Đáp án đúng: ").append(req.getCorrectAnswer()).append("\n");

        if (req.getExplanation() != null && !req.getExplanation().isEmpty()) {
            sb.append("Ghi chú: ").append(req.getExplanation()).append("\n");
        }

        sb.append("\n");
        if (isCorrect) {
            sb.append("Tôi làm đúng rồi. Hãy giải thích ngắn gọn tại sao đáp án này đúng về mặt ngữ pháp.");
        } else {
            sb.append("Tôi làm sai. Hãy giải thích tại sao tôi sai và tại sao đáp án kia mới đúng. Giải thích ngắn gọn, dễ hiểu.");
        }

        return sb.toString();
    }
}