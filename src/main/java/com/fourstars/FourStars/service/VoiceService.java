package com.fourstars.FourStars.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class VoiceService {

    private static final Logger logger = LoggerFactory.getLogger(VoiceService.class);
    private final RestClient restClient;

    // Lấy URL gốc từ cấu hình (ví dụ: http://fourstars-nlp-api:8000/api/chat)
    // Ta sẽ cắt bớt đuôi /chat để ghép endpoint mới
    @Value("${NLP_API_URL}") 
    private String nlpApiUrl; 

    public VoiceService(RestClient.Builder builder) {
        this.restClient = builder.build();
    }

    public String chatWithVoice(MultipartFile audioFile) throws IOException {
        // 1. Xác định URL của Python Service cho Voice
        String voiceEndpoint = nlpApiUrl.replace("/api/chat", "") + "";
        
        logger.info("Calling Voice API at: {}", voiceEndpoint);

        // 2. Đóng gói file để gửi đi
        MultipartBodyBuilder bodyBuilder = new MultipartBodyBuilder();
        bodyBuilder.part("file", new ByteArrayResource(audioFile.getBytes()) {
            @Override
            public String getFilename() {
                // Python cần tên file có đuôi (vd: .webm, .wav) để xử lý đúng
                return audioFile.getOriginalFilename() != null ? audioFile.getOriginalFilename() : "audio.webm";
            }
        });

        // 3. Gửi Request sang Python
        try {
            return restClient.post()
                    .uri(voiceEndpoint)
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(bodyBuilder.build())
                    .retrieve()
                    .body(String.class);
        } catch (Exception e) {
            logger.error("Error calling Python Voice API", e);
            throw new IOException("Không thể kết nối tới AI Service: " + e.getMessage());
        }
    }
}