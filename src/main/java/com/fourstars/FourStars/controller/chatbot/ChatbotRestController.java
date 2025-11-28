// src/main/java/com/fourstars/FourStars/controller/chatbot/ChatbotRestController.java
package com.fourstars.FourStars.controller.chatbot;

import com.fourstars.FourStars.domain.request.chatbot.ExplainRequestDTO;
import com.fourstars.FourStars.service.ChatbotService;
import com.fourstars.FourStars.util.annotation.ApiMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/chatbot")
@RequiredArgsConstructor
public class ChatbotRestController {

    private final ChatbotService chatbotService;

    @PostMapping("/explain")
    @ApiMessage("Generate AI explanation for quiz result")
    public ResponseEntity<Map<String, String>> requestExplanation(@RequestBody ExplainRequestDTO request) {
        // Gọi service và nhận kết quả
        String explanation = chatbotService.generateExplanation(request);

        // Trả về JSON: { "reply": "Nội dung giải thích..." }
        return ResponseEntity.ok(Map.of("reply", explanation));
    }
}