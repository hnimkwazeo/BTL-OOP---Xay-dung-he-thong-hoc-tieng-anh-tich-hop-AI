package com.fourstars.FourStars.domain.request.question;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class QuestionDTO {
    private Long id;
    private Long quizId;
    private String questionType; // FE gửi string (VD: "MULTIPLE_CHOICE_TEXT")
    private String prompt;
    private String textToFill;
    private String correctSentence;
    private String audioUrl;
    private String imageUrl;
    private Integer points;
    private Integer questionOrder;
    private List<QuestionChoiceDTO> choices; // Dùng List để hứng JSON array

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class QuestionChoiceDTO {
        private Long id;
        private String content;
        private String imageUrl;
        @JsonProperty("isCorrect") 
        private boolean isCorrect;
    }
}