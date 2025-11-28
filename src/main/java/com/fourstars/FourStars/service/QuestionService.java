package com.fourstars.FourStars.service;

import com.fourstars.FourStars.domain.Question;
import com.fourstars.FourStars.domain.QuestionChoice;
import com.fourstars.FourStars.domain.Quiz;
import com.fourstars.FourStars.domain.request.question.QuestionDTO;
import com.fourstars.FourStars.repository.QuestionRepository;
import com.fourstars.FourStars.repository.QuizRepository;
import com.fourstars.FourStars.util.constant.QuestionType; 
import com.fourstars.FourStars.util.error.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionService {
    private final QuestionRepository questionRepository;
    private final QuizRepository quizRepository;

    @Transactional
    public QuestionDTO createQuestion(QuestionDTO dto) {
        Quiz quiz = quizRepository.findById(dto.getQuizId())
                .orElseThrow(() -> new ResourceNotFoundException("Quiz not found id: " + dto.getQuizId()));
        Question question = new Question();
        question.setQuiz(quiz);
        mapDtoToEntity(dto, question);
        
        if (dto.getChoices() != null) {
            Set<QuestionChoice> choices = new HashSet<>();
            for (QuestionDTO.QuestionChoiceDTO cDto : dto.getChoices()) {
                QuestionChoice c = new QuestionChoice();
                c.setContent(cDto.getContent());
                c.setImageUrl(cDto.getImageUrl());
                c.setCorrect(cDto.isCorrect());
                c.setQuestion(question);
                choices.add(c);
            }
            question.setChoices(choices);
        }
        return convertToDTO(questionRepository.save(question));
    }

    @Transactional
    public QuestionDTO updateQuestion(long id, QuestionDTO dto) {
        Question existing = questionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Question not found id: " + id));
        
        mapDtoToEntity(dto, existing);

        if (dto.getChoices() != null) {
            Set<QuestionChoice> currentChoices = existing.getChoices();
            if (currentChoices == null) {
                currentChoices = new HashSet<>();
                existing.setChoices(currentChoices);
            }

            Map<Long, QuestionChoice> currentChoiceMap = currentChoices.stream()
                .collect(Collectors.toMap(QuestionChoice::getId, c -> c));

            Set<Long> dtoIds = new HashSet<>();

            for (QuestionDTO.QuestionChoiceDTO cDto : dto.getChoices()) {
                if (cDto.getId() != null && currentChoiceMap.containsKey(cDto.getId())) {
                    QuestionChoice existingChoice = currentChoiceMap.get(cDto.getId());
                    existingChoice.setContent(cDto.getContent());
                    existingChoice.setImageUrl(cDto.getImageUrl());
                    existingChoice.setCorrect(cDto.isCorrect());
                    dtoIds.add(cDto.getId());
                } else {
                    QuestionChoice newChoice = new QuestionChoice();
                    newChoice.setContent(cDto.getContent());
                    newChoice.setImageUrl(cDto.getImageUrl());
                    newChoice.setCorrect(cDto.isCorrect());
                    newChoice.setQuestion(existing);
                    currentChoices.add(newChoice);
                }
            }

            currentChoices.removeIf(c -> c.getId() != 0 && !dtoIds.contains(c.getId()));
        }

        return convertToDTO(questionRepository.save(existing));
    }

    @Transactional
    public void deleteQuestion(long id) {
        if (!questionRepository.existsById(id)) throw new ResourceNotFoundException("Question not found id: " + id);
        questionRepository.deleteById(id);
    }

    private void mapDtoToEntity(QuestionDTO dto, Question q) {
        try { q.setQuestionType(QuestionType.valueOf(dto.getQuestionType())); } 
        catch (Exception e) { q.setQuestionType(QuestionType.MULTIPLE_CHOICE_TEXT); }
        q.setPrompt(dto.getPrompt());
        q.setTextToFill(dto.getTextToFill());
        q.setCorrectSentence(dto.getCorrectSentence());
        q.setAudioUrl(dto.getAudioUrl());
        q.setImageUrl(dto.getImageUrl());
        q.setPoints(dto.getPoints() != null ? dto.getPoints() : 10);
        q.setQuestionOrder(dto.getQuestionOrder() != null ? dto.getQuestionOrder() : 0);
    }

    private QuestionDTO convertToDTO(Question q) {
        QuestionDTO dto = new QuestionDTO(q.getId(), q.getQuiz().getId(), q.getQuestionType().name(), q.getPrompt(), q.getTextToFill(), q.getCorrectSentence(), q.getAudioUrl(), q.getImageUrl(), q.getPoints(), q.getQuestionOrder(), null);
        if (q.getChoices() != null) {
            dto.setChoices(q.getChoices().stream().map(c -> new QuestionDTO.QuestionChoiceDTO(c.getId(), c.getContent(), c.getImageUrl(), c.isCorrect())).collect(Collectors.toList()));
        }
        return dto;
    }
}