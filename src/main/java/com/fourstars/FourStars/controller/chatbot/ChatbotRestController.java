package com.fourstars.FourStars.controller.chatbot;

import com.fourstars.FourStars.domain.DictationSentence;
import com.fourstars.FourStars.domain.request.chatbot.ChatRequestDTO;
import com.fourstars.FourStars.domain.request.chatbot.ExplainRequestDTO;
import com.fourstars.FourStars.domain.response.chatbot.ChatResponseDTO;
import com.fourstars.FourStars.repository.DictationSentenceRepository;
import com.fourstars.FourStars.service.ChatbotService;
import com.fourstars.FourStars.util.annotation.ApiMessage;
import com.fourstars.FourStars.util.error.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/chatbot")
@RequiredArgsConstructor // 1. Dùng Lombok để tự tạo Constructor (Clean code)
public class ChatbotRestController {

    private final ChatbotService chatbotService;
    private final DictationSentenceRepository dictationSentenceRepository;

    // --- API 1: Dành cho phần Dictation (Giữ nguyên logic cũ của bạn) ---
    @PostMapping("/explain-dictation")
    @ApiMessage("Explain dictation sentence")
    public ResponseEntity<ChatResponseDTO> explainDictation(@RequestBody ExplainRequestDTO request) {
        // Lấy thông tin câu gốc từ Database
        DictationSentence sentence = dictationSentenceRepository.findById(request.getSentenceId())
                .orElseThrow(() -> new ResourceNotFoundException("Sentence not found"));

        // Xây dựng Prompt
        String prompt = buildExplanationPrompt(sentence.getCorrectText(), request.getUserText());

        // Tạo request giả lập
        ChatRequestDTO chatRequest = new ChatRequestDTO();
        chatRequest.setMessage(prompt);
        
        // Gọi AI qua hàm cũ (có lưu lịch sử chat)
        ChatResponseDTO response = chatbotService.getChatbotResponse(chatRequest);

        return ResponseEntity.ok(response);
    }

    // --- API 2: Dành cho phần Quiz/Grammar (Logic mới từ đoạn text) ---
    @PostMapping("/explain")
    @ApiMessage("Generate AI explanation for quiz/grammar")
    public ResponseEntity<Map<String, String>> requestExplanation(@RequestBody ExplainRequestDTO request) {
        // Gọi service xử lý logic (Logic nằm bên service để controller gọn nhẹ)
        String explanation = chatbotService.requestExplanation(request);

        // Trả về JSON đơn giản: { "reply": "Nội dung..." }
        return ResponseEntity.ok(Map.of("reply", explanation));
    }

    // --- Helper Method: Xây dựng prompt cho Dictation ---
    private String buildExplanationPrompt(String correctText, String userText) {
        StringBuilder sb = new StringBuilder();
        sb.append("Tôi đang luyện nghe chép chính tả câu này:\n");
        sb.append("\"").append(correctText).append("\"\n\n");
        
        if (userText != null && !userText.isBlank()) {
            sb.append("Tôi đã nghe và viết lại là: \"").append(userText).append("\"\n");
            sb.append("Hãy giải thích chi tiết ngữ pháp, từ vựng của câu đúng và chỉ ra lỗi sai của tôi (nếu có).");
        } else {
            sb.append("Hãy giải thích chi tiết cấu trúc ngữ pháp và từ vựng quan trọng trong câu này giúp tôi.");
        }
        return sb.toString();
    }
}