package com.fourstars.FourStars.controller.chatbot;

import com.fourstars.FourStars.service.VoiceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
// SỬA TẠI ĐÂY: Thêm đường dẫn cơ sở để khớp với Frontend
@RequestMapping("/api/v1/voice") 
public class VoiceController {

    private final VoiceService voiceService;

    public VoiceController(VoiceService voiceService) {
        this.voiceService = voiceService;
    }

    // API này sẽ lắng nghe tại: POST /api/v1/voice/chat
    @PostMapping(value = "/chat", consumes = "multipart/form-data")
    public ResponseEntity<?> chatByVoice(@RequestParam("file") MultipartFile file) {
        try {
            // Gọi service (Service đã chứa logic mới gọi Python 2 bước)
            String response = voiceService.chatWithVoice(file);
            
            // Trả về JSON: { "user_text": "...", "bot_response": "..." }
            return ResponseEntity.ok(response);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().body("{\"error\": \"Lỗi xử lý file âm thanh: " + e.getMessage() + "\"}");
        }
    }
}