package com.fourstars.FourStars.domain.request.chatbot;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatRequestDTO {

    @NotBlank(message = "Nội dung tin nhắn không được để trống")
    private String message;

    // Thêm trường này nếu frontend có thể truyền lên ID của phiên cũ (tùy chọn)
    private String conversationId;
}