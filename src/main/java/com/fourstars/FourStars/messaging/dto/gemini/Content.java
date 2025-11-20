package com.fourstars.FourStars.messaging.dto.gemini;

import java.util.List;

public record Content(List<Part> parts, String role) {
}
