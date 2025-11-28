package com.fourstars.FourStars.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

@Entity
@Table(name = "question_choices")
@Getter
@Setter
@SQLDelete(sql = "UPDATE question_choices SET deleted = true WHERE id=?")
@SQLRestriction("deleted = false")
public class QuestionChoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    private String content;

    @Column(length = 2048)
    private String imageUrl;

    @Column(nullable = false)
    private boolean isCorrect = false;

    @Column(nullable = false)
    private boolean deleted = false;
}