package com.fourstars.FourStars.controller.chatbot;

import com.fourstars.FourStars.service.VoiceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("")
public class VoiceController {
    private final VoiceService voiceService;

    public VoiceController(VoiceService voiceService) {
        this.voiceService = voiceService;
    }

    @PostMapping(value = "/chat", consumes = "multipart/form-data")
    public ResponseEntity<?> chatByVoice(@RequestParam("file") MultipartFile file) {
        try {
            String response = voiceService.chatWithVoice(file);
            return ResponseEntity.ok(response);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().body("Lỗi xử lý file âm thanh: " + e.getMessage());
        }
    }
}