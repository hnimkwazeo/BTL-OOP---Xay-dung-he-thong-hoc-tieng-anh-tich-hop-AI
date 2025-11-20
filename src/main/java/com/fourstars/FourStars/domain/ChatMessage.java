package com.fourstars.FourStars.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.Instant;

@Entity
@Table(name = "chat_message")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Liên kết với người dùng (ví dụ: User.java)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // ID của phiên trò chuyện, dùng để nhóm các tin nhắn liên quan
    @Column(name = "conversation_id", nullable = false)
    private String conversationId;

    // Vai trò: 'user' (tin nhắn của người dùng) hoặc 'assistant' (tin nhắn của AI)
    @Column(name = "role", nullable = false)
    private String role;

    @Lob // Để lưu trữ nội dung tin nhắn lớn
    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}