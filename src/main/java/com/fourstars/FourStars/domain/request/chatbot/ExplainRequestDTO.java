package com.fourstars.FourStars.domain.request.chatbot;

import lombok.Data;

@Data
public class ExplainRequestDTO {
    private String questionContent; // Nội dung câu hỏi/từ vựng
    private String userAnswer;      // Đáp án user chọn (có thể null nếu là bài tự luận hoặc chỉ tra từ)
    private String correctAnswer;   // Đáp án đúng của hệ thống
    private String explanation;     // Giải thích ngắn có sẵn của hệ thống (nếu có)
    private String type;            // "QUIZ", "VOCABULARY", "GRAMMAR"
}