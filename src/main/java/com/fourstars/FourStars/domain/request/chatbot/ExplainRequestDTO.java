package com.fourstars.FourStars.domain.request.chatbot;

import lombok.Data;

@Data
public class ExplainRequestDTO {
    private Long sentenceId;  
    private String userText;  

    private String questionContent; 
    private String userAnswer;      
    private String correctAnswer;   
    private String explanation;    
    private String type;
}