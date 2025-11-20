package com.fourstars.FourStars.repository;

import com.fourstars.FourStars.domain.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import com.fourstars.FourStars.domain.User;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    // Truy vấn N tin nhắn gần nhất trong một phiên trò chuyện
    List<ChatMessage> findByConversationIdOrderByCreatedAtDesc(String conversationId, Pageable pageable);

    // Truy vấn phiên trò chuyện gần nhất của người dùng
    Optional<ChatMessage> findFirstByUserEmailOrderByCreatedAtDesc(String email);

    Optional<ChatMessage> findFirstByUserOrderByCreatedAtDesc(User user);
}