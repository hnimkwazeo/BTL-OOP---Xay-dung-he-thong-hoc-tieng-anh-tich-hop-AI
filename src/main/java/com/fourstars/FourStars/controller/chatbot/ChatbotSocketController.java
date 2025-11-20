package com.fourstars.FourStars.controller.chatbot;

import java.security.Principal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

import com.fourstars.FourStars.domain.request.chatbot.ChatRequestDTO;
import com.fourstars.FourStars.domain.response.chatbot.ChatResponseDTO;
import com.fourstars.FourStars.service.ChatbotService;

@Controller
public class ChatbotSocketController {

    private final ChatbotService chatbotService;
    private final SimpMessageSendingOperations messagingTemplate;
    private static final Logger logger = LoggerFactory.getLogger(ChatbotSocketController.class);

    @Autowired
    public ChatbotSocketController(ChatbotService chatbotService, SimpMessageSendingOperations messagingTemplate) {
        this.chatbotService = chatbotService;
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * ĐƯỜNG DẪN NÀY ĐÃ ĐÚNG (KHỚP VỚI LOG CỦA BẠN)
     */
    @MessageMapping("/chat.sendMessage") 
    public void handleChatMessage(@Payload ChatRequestDTO chatRequest, Principal principal) {
        String userEmail = principal.getName();
        
        /**
         * THÊM KHỐI try...catch NÀY
         */
        try {
            // 1. Gọi service 
            ChatResponseDTO response = chatbotService.getChatbotResponse(chatRequest);

            // 2. Trả lời khi thành công
            messagingTemplate.convertAndSendToUser(userEmail, "/queue/chat.reply", response);

        } catch (Exception e) {
            // 3. Ghi log lỗi ra console Spring Boot (Rất quan trọng!)
            logger.error("!!! LỖI KHI CHẠY CHATBOT SERVICE: {}", e.getMessage(), e);
            
            // 4. Báo lỗi về cho client 
            ChatResponseDTO errorResponse = new ChatResponseDTO();
            errorResponse.setAssistantResponse("Rất tiếc, đã có lỗi máy chủ: " + e.getMessage());
            errorResponse.setConversationId(chatRequest.getConversationId()); 

            messagingTemplate.convertAndSendToUser(userEmail, "/queue/chat.reply", errorResponse);
        }
    }
}