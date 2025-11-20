package com.fourstars.FourStars.messaging.dto.gemini;

import java.util.List;


public record GeminiResponse(List<Candidate> candidates) {

    public String getFirstText() {
        if (candidates != null && !candidates.isEmpty()) {
            Candidate firstCandidate = candidates.get(0);
            if (firstCandidate != null && firstCandidate.content() != null &&
                firstCandidate.content().parts() != null && !firstCandidate.content().parts().isEmpty()) {
                return firstCandidate.content().parts().get(0).text();
            }
        }
        return "Xin lỗi, tôi không thể tạo ra câu trả lời.";
    }
}

record Candidate(ContentResponse content) {}
record ContentResponse(List<Part> parts) {}
