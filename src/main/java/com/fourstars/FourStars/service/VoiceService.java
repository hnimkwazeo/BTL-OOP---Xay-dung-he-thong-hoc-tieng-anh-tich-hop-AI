package com.fourstars.FourStars.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestTemplate; // Dùng cái này
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class VoiceService {

    private static final Logger logger = LoggerFactory.getLogger(VoiceService.class);
    
    // Dùng RestTemplate cho tất cả các request (Upload File + Chat JSON)
    // Vì nó xử lý Multipart ổn định hơn RestClient trong trường hợp này
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${NLP_API_URL}") 
    private String pythonBaseUrl; 

    // Constructor có thể bỏ RestClient.Builder nếu không dùng RestClient nữa
    // Nhưng cứ để lại để tránh lỗi Bean nếu chỗ khác cần
    public VoiceService(RestClient.Builder builder) {
    }

    // Class DTO hứng kết quả
    private static class PythonResponse {
        public String text;
        public String error;
    }

    public String chatWithVoice(MultipartFile audioFile) throws IOException {
        logger.info("=== START VOICE CHAT (RestTemplate Version) ===");

        // -------------------------------------------------------
        // BƯỚC 1: Transcribe (Dùng RestTemplate gửi Multipart)
        // -------------------------------------------------------
        String transcribeUrl = pythonBaseUrl + "/transcribe";
        
        // Tạo Header Multipart
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        // Tạo Body (MultiValueMap)
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        
        // QUAN TRỌNG: Key phải là "audio"
        body.add("audio", new ByteArrayResource(audioFile.getBytes()) {
            @Override
            public String getFilename() {
                // Bắt buộc phải có tên file có đuôi .wav/.mp3 để Python nhận diện
                return "audio.wav";
            }
        });

        // Đóng gói Request
        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        PythonResponse sttResult = null;
        try {
            logger.info("Calling Transcribe API: {}", transcribeUrl);
            // Gửi bằng RestTemplate
            sttResult = restTemplate.postForObject(transcribeUrl, requestEntity, PythonResponse.class);
        } catch (Exception e) {
            logger.error("Lỗi Transcribe: ", e);
            return "{\"error\": \"Lỗi kết nối nhận diện giọng nói.\"}";
        }

        if (sttResult == null || sttResult.text == null) {
            logger.error("Transcribe trả về null");
            return "{\"error\": \"Không nghe rõ bạn nói gì.\"}";
        }
        
        String userText = sttResult.text;
        logger.info("User Text: {}", userText);

        // -------------------------------------------------------
        // BƯỚC 2: Chat (Dùng RestTemplate gửi JSON String)
        // -------------------------------------------------------
        String chatUrl = pythonBaseUrl + "/api/chat";
        
        // Escape JSON thủ công để an toàn
        String safeUserText = userText.replace("\"", "\\\"").replace("\n", " ");
        String jsonBody = "{\"message\": \"" + safeUserText + "\"}";

        HttpHeaders chatHeaders = new HttpHeaders();
        chatHeaders.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> chatEntity = new HttpEntity<>(jsonBody, chatHeaders);

        PythonResponse chatResult = null;
        try {
            chatResult = restTemplate.postForObject(chatUrl, chatEntity, PythonResponse.class);
        } catch (Exception e) {
            logger.error("Lỗi Chat AI: ", e);
            return String.format("{\"user_text\": \"%s\", \"bot_response\": \"Lỗi xử lý AI.\"}", safeUserText);
        }

        String botResponse = (chatResult != null && chatResult.text != null) ? chatResult.text : "AI không trả lời.";
        String safeBotResponse = botResponse.replace("\"", "\\\"").replace("\n", "\\n");

        return String.format("{\"user_text\": \"%s\", \"bot_response\": \"%s\"}", safeUserText, safeBotResponse);
    }
}