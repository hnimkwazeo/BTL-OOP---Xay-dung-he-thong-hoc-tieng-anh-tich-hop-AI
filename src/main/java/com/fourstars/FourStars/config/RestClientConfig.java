package com.fourstars.FourStars.config;

import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestClient;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value; 

@Configuration 
public class RestClientConfig {
    
    // === SỬA LỖI Ở ĐÂY ===
    // Thêm URL mặc định để ứng dụng không sập (crash)
    @Value("${GEMINI_API_URL}")
    private String geminiApiurl;   
    
    @Bean
    public RestClient geminiRestClient() {
        return RestClient.builder()
                         .baseUrl(geminiApiurl)
                         .build();
    }
}