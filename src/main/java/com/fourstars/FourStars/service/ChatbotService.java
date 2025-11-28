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
@RequiredArgsConstructor // Tự động inject dependency (Clean code)
public class ChatbotService {

    private static final Logger logger = LoggerFactory.getLogger(ChatbotService.class);
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;

    // Khởi tạo RestTemplate trực tiếp
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${NLP_API_URL}")
    private String nlpApiUrl;

    @Data
    @NoArgsConstructor
    private static class PythonAiResponse {
        private String text;
        private String error;
    }

    // ========================================================================
    // 1. LOGIC CHAT & DICTATION (Logic cũ đã được Refactor sạch đẹp)
    // ========================================================================
    public ChatResponseDTO getChatbotResponse(ChatRequestDTO request) {
        User currentUser = getCurrentUserEntity();

        // Lấy hoặc tạo Conversation ID
        String conversationId = (request.getConversationId() != null && !request.getConversationId().isBlank())
                ? request.getConversationId()
                : getLatestOrNewConversationId(currentUser);

        // Gọi AI
        String assistantResponseText = callPythonAI(request.getMessage());

        // Lưu lịch sử chat
        saveMessageToDB(currentUser, conversationId, "user", request.getMessage());
        saveMessageToDB(currentUser, conversationId, "assistant", assistantResponseText);

        return new ChatResponseDTO(assistantResponseText, conversationId);
    }

    // ========================================================================
    // 2. LOGIC GIẢI THÍCH BÀI TẬP QUIZ (Mới thêm vào)
    // ========================================================================
    public String requestExplanation(ExplainRequestDTO req) {
        User currentUser = getCurrentUserEntity();
        String conversationId = getLatestOrNewConversationId(currentUser);

        // 1. Tạo Prompt thông minh dựa trên câu trả lời đúng/sai
        String prompt = buildSmartPrompt(req);

        // 2. Gọi AI
        String aiResponse = callPythonAI(prompt);

        // 3. Lưu vào lịch sử (để user xem lại được trong lịch sử chat chung)
        saveMessageToDB(currentUser, conversationId, "user", prompt);
        saveMessageToDB(currentUser, conversationId, "assistant", aiResponse);

        return aiResponse;
    }

    // ========================================================================
    // 3. PRIVATE HELPER METHODS (Dùng chung cho cả 2 luồng)
    // ========================================================================

    // Gọi API Python
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
            return "Xin lỗi, tôi đang gặp sự cố kết nối với máy chủ AI (" + e.getMessage() + ")";
        }
    }

    // Lưu tin nhắn vào DB
    private void saveMessageToDB(User user, String conversationId, String role, String content) {
        ChatMessage msg = new ChatMessage();
        msg.setUser(user);
        msg.setConversationId(conversationId);
        msg.setRole(role);
        msg.setContent(content);
        msg.setCreatedAt(Instant.now());
        chatMessageRepository.save(msg);
    }

    // Lấy User hiện tại
    private User getCurrentUserEntity() {
        return SecurityUtil.getCurrentUserLogin()
                .flatMap(userRepository::findByEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not authenticated"));
    }

    // Quản lý Conversation ID
    private String getLatestOrNewConversationId(User user) {
        return chatMessageRepository.findFirstByUserOrderByCreatedAtDesc(user)
                .map(ChatMessage::getConversationId)
                .orElse(UUID.randomUUID().toString());
    }

    // Xây dựng Prompt cho Quiz
    private String buildSmartPrompt(ExplainRequestDTO req) {
        StringBuilder sb = new StringBuilder();
        
        // Kiểm tra đúng sai cơ bản (có thể logic frontend gửi lên đã có, nhưng check lại cho chắc)
        boolean isCorrect = req.getUserAnswer() != null 
                && req.getUserAnswer().equalsIgnoreCase(req.getCorrectAnswer());

        sb.append("Tôi đang làm bài tập và cần giải thích.\n");
        sb.append("Câu hỏi: \"").append(req.getQuestionContent()).append("\"\n");
        
        if (req.getUserAnswer() != null) {
            sb.append("Câu trả lời của tôi: \"").append(req.getUserAnswer()).append("\"\n");
        }
        sb.append("Đáp án đúng: \"").append(req.getCorrectAnswer()).append("\"\n");

        // Nếu câu hỏi có giải thích sẵn từ hệ thống
        if (req.getExplanation() != null && !req.getExplanation().isEmpty()) {
            sb.append("Ghi chú gốc của bài: ").append(req.getExplanation()).append("\n");
        }

        sb.append("\n");
        if (isCorrect) {
            sb.append("Tôi đã làm đúng. Hãy phân tích ngắn gọn cấu trúc ngữ pháp giúp tôi hiểu sâu hơn.");
        } else {
            sb.append("Tôi đã làm sai. Hãy giải thích tại sao tôi sai và phân tích đáp án đúng một cách dễ hiểu.");
        }

        return sb.toString();
    }
}