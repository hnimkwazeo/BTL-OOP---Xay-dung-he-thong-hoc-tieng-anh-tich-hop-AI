package com.fourstars.FourStars.domain.response.chatbot;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatResponseDTO {

    private String assistantResponse;
    private String conversationId; // ID phiên hiện tại
    // Có thể thêm thông tin khác như thời gian phản hồi, token count,...
}