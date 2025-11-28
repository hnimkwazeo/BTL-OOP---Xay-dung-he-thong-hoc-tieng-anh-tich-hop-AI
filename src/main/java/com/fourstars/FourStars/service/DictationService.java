package com.fourstars.FourStars.service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fourstars.FourStars.domain.Category;
import com.fourstars.FourStars.domain.DictationSentence;
import com.fourstars.FourStars.domain.DictationTopic;
import com.fourstars.FourStars.domain.request.dictation.DictationTopicRequestDTO;
import com.fourstars.FourStars.domain.response.ResultPaginationDTO;
import com.fourstars.FourStars.domain.response.dictation.DictationSentenceResponseDTO;
import com.fourstars.FourStars.domain.response.dictation.DictationTopicResponseDTO;
import com.fourstars.FourStars.domain.response.dictation.NlpAnalysisResponse;
import com.fourstars.FourStars.repository.CategoryRepository;
import com.fourstars.FourStars.repository.DictationSentenceRepository;
import com.fourstars.FourStars.repository.DictationTopicRepository;
import com.fourstars.FourStars.util.error.ResourceNotFoundException;

import jakarta.persistence.criteria.Predicate;

@Service
public class DictationService {
    private static final Logger logger = LoggerFactory.getLogger(DictationService.class);

    private final DictationTopicRepository topicRepository;
    private final CategoryRepository categoryRepository;
    private final DictationSentenceRepository sentenceRepository;

    public DictationService(DictationTopicRepository topicRepository,
            CategoryRepository categoryRepository,
            DictationSentenceRepository sentenceRepository) {
        this.topicRepository = topicRepository;
        this.categoryRepository = categoryRepository;
        this.sentenceRepository = sentenceRepository;
    }

    @Transactional
    public DictationTopicResponseDTO createDictationTopic(DictationTopicRequestDTO requestDTO) {
        logger.info("Admin creating new dictation topic with title: '{}'", requestDTO.getTitle());
        Category category = categoryRepository.findById(requestDTO.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Category not found with id: " + requestDTO.getCategoryId()));

        DictationTopic topic = new DictationTopic();
        topic.setTitle(requestDTO.getTitle());
        topic.setDescription(requestDTO.getDescription());
        topic.setCategory(category);

        requestDTO.getSentences().forEach(sentenceDTO -> {
            DictationSentence sentence = new DictationSentence();
            sentence.setAudioUrl(sentenceDTO.getAudioUrl());
            sentence.setCorrectText(sentenceDTO.getCorrectText());
            sentence.setOrderIndex(sentenceDTO.getOrderIndex());
            topic.addSentence(sentence);
        });

        DictationTopic savedTopic = topicRepository.save(topic);
        logger.info("Successfully created dictation topic with ID: {}", savedTopic.getId());
        return convertToAdminDTO(savedTopic);
    }

    @Transactional
    public DictationTopicResponseDTO updateDictationTopic(long topicId, DictationTopicRequestDTO requestDTO) {
        logger.info("Admin updating dictation topic with ID: {}", topicId);
        DictationTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation topic not found with id: " + topicId));

        Category category = categoryRepository.findById(requestDTO.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Category not found with id: " + requestDTO.getCategoryId()));

        topic.setTitle(requestDTO.getTitle());
        topic.setDescription(requestDTO.getDescription());
        topic.setCategory(category);

        topic.getSentences().clear();
        requestDTO.getSentences().forEach(sentenceDTO -> {
            DictationSentence sentence = new DictationSentence();
            sentence.setAudioUrl(sentenceDTO.getAudioUrl());
            sentence.setCorrectText(sentenceDTO.getCorrectText());
            sentence.setOrderIndex(sentenceDTO.getOrderIndex());
            topic.addSentence(sentence);
        });

        DictationTopic updatedTopic = topicRepository.save(topic);
        logger.info("Successfully updated dictation topic with ID: {}", updatedTopic.getId());
        return convertToAdminDTO(updatedTopic);
    }

    @Transactional
    public void deleteDictationTopic(long topicId) {
        logger.info("Admin deleting dictation topic with ID: {}", topicId);
        if (!topicRepository.existsById(topicId)) {
            throw new ResourceNotFoundException("Dictation topic not found with id: " + topicId);
        }
        topicRepository.deleteById(topicId);
        logger.info("Successfully deleted dictation topic with ID: {}", topicId);
    }

    @Transactional(readOnly = true)
    public DictationTopicResponseDTO getDictationTopicById(long topicId) {
        logger.debug("Fetching dictation topic with ID: {}", topicId);
        DictationTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation topic not found with id: " + topicId));
        return convertToAdminDTO(topic);
    }

    @Transactional(readOnly = true)
    public ResultPaginationDTO<DictationTopicResponseDTO> fetchAllTopics(
            Pageable pageable,
            Long categoryId,
            String title,
            LocalDate startCreatedAt,
            LocalDate endCreatedAt) {
        logger.debug("Fetching all dictation topics with filters");

        Specification<DictationTopic> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (categoryId != null) {
                predicates.add(criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }
            if (title != null && !title.trim().isEmpty()) {
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("title")),
                        "%" + title.trim().toLowerCase() + "%"));
            }
            if (startCreatedAt != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"),
                        startCreatedAt.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            }
            if (endCreatedAt != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"),
                        endCreatedAt.atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant()));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        Page<DictationTopic> topicPage = topicRepository.findAll(spec, pageable);

        List<DictationTopicResponseDTO> dtoList = topicPage.getContent().stream()
                .map(this::convertToAdminDTO)
                .collect(Collectors.toList());

        ResultPaginationDTO.Meta meta = new ResultPaginationDTO.Meta(
                topicPage.getNumber() + 1,
                topicPage.getSize(),
                topicPage.getTotalPages(),
                topicPage.getTotalElements());
        return new ResultPaginationDTO<>(meta, dtoList);
    }

    @Transactional(readOnly = true)
    public ResultPaginationDTO<DictationTopicResponseDTO> fetchAllTopicsForUser(
            Pageable pageable,
            Long categoryId,
            String title,
            LocalDate startCreatedAt,
            LocalDate endCreatedAt) {
        logger.debug("Fetching all dictation topics with filters");

        Specification<DictationTopic> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (categoryId != null) {
                predicates.add(criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }
            if (title != null && !title.trim().isEmpty()) {
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("title")),
                        "%" + title.trim().toLowerCase() + "%"));
            }
            if (startCreatedAt != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"),
                        startCreatedAt.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            }
            if (endCreatedAt != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"),
                        endCreatedAt.atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant()));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        Page<DictationTopic> topicPage = topicRepository.findAll(spec, pageable);

        List<DictationTopicResponseDTO> dtoList = topicPage.getContent().stream()
                .map(topic -> convertToUserResponseDTO(topic, false))
                .collect(Collectors.toList());

        ResultPaginationDTO.Meta meta = new ResultPaginationDTO.Meta(
                topicPage.getNumber() + 1,
                topicPage.getSize(),
                topicPage.getTotalPages(),
                topicPage.getTotalElements());
        return new ResultPaginationDTO<>(meta, dtoList);
    }

    @Transactional(readOnly = true)
    public DictationTopicResponseDTO getDictationTopicForUser(long topicId) {
        logger.debug("User fetching dictation topic with ID: {}", topicId);
        DictationTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation topic not found with id: " + topicId));
        return convertToAdminDTO(topic);
    }

    // === HÀM XỬ LÝ CHẤM ĐIỂM (PARTIAL SCORING) ===
    @Transactional(readOnly = true)
    public NlpAnalysisResponse submitAndAnalyze(long sentenceId, String userText) {
        logger.info("User submitting answer for sentence ID: {}", sentenceId);

        DictationSentence sentence = sentenceRepository.findById(sentenceId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation sentence not found with id: " + sentenceId));

        String correctText = sentence.getCorrectText();
        NlpAnalysisResponse response = new NlpAnalysisResponse();

        if (correctText == null) {
            response.setScore(0);
            return response;
        }

        // Nếu người dùng không nhập gì
        if (userText == null || userText.trim().isEmpty()) {
            response.setScore(0);
            return response;
        }

        // 1. Chuẩn hóa chuỗi (bỏ dấu câu, chuyển về thường) để so sánh nội dung
        String normCorrect = normalizeText(correctText);
        String normUser = normalizeText(userText);

        if (normCorrect.isEmpty()) {
            // Trường hợp DB lưu câu rỗng (ít xảy ra), coi như người dùng đúng nếu cũng nhập rỗng
            response.setScore(normUser.isEmpty() ? 100 : 0);
            return response;
        }

        // 2. Tính khoảng cách Levenshtein
        int distance = calculateLevenshteinDistance(normCorrect, normUser);

        // 3. Tính điểm phần trăm
        // Điểm = (1 - distance / max_length) * 100
        int maxLength = Math.max(normCorrect.length(), normUser.length());
        double similarity = 1.0 - ((double) distance / maxLength);

        // Làm tròn điểm (ví dụ: 90.5 -> 91)
        int score = (int) Math.round(similarity * 100);

        // Đảm bảo không âm (phòng trường hợp thuật toán lỗi, dù logic trên luôn >= 0)
        score = Math.max(0, score);

        response.setScore(score);

        // Bạn có thể thêm logic tạo Diff ở đây nếu muốn hiển thị chữ xanh/đỏ
        // response.setDiffs(...);

        return response;
    }

    // Hàm hỗ trợ: Chuẩn hóa text (chữ thường, bỏ dấu câu đặc biệt)
    private String normalizeText(String text) {
        if (text == null) return "";
        // Chuyển thường và loại bỏ các ký tự không phải chữ/số (giữ lại khoảng trắng)
        // Ví dụ: "Hello, World!" -> "hello world"
        return text.toLowerCase()
                   .replaceAll("[^a-zA-Z0-9\\s]", "") // Bỏ dấu câu
                   .replaceAll("\\s+", " ")           // Gộp nhiều khoảng trắng thành 1
                   .trim();
    }

    // Hàm hỗ trợ: Thuật toán Levenshtein Distance (Quy hoạch động)
    private int calculateLevenshteinDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];

        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    int cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;
                    dp[i][j] = min(dp[i - 1][j] + 1,      // Deletion
                                   dp[i][j - 1] + 1,      // Insertion
                                   dp[i - 1][j - 1] + cost); // Substitution
                }
            }
        }
        return dp[s1.length()][s2.length()];
    }

    private int min(int a, int b, int c) {
        return Math.min(Math.min(a, b), c);
    }

    private DictationTopicResponseDTO convertToUserResponseDTO(DictationTopic topic, boolean includeSentences) {
        DictationTopicResponseDTO topicDto = new DictationTopicResponseDTO();
        topicDto.setId(topic.getId());
        topicDto.setTitle(topic.getTitle());
        topicDto.setDescription(topic.getDescription());
        if (topic.getCategory() != null) {
            DictationTopicResponseDTO.CategoryInfoDTO catInfo = new DictationTopicResponseDTO.CategoryInfoDTO();
            catInfo.setId(topic.getCategory().getId());
            catInfo.setName(topic.getCategory().getName());
            topicDto.setCategory(catInfo);
        }
        topicDto.setCreatedAt(topic.getCreatedAt());
        topicDto.setUpdatedAt(topic.getUpdatedAt());
        topicDto.setCreatedBy(topic.getCreatedBy());
        topicDto.setUpdatedBy(topic.getUpdatedBy());
        if (includeSentences) {
            List<DictationSentenceResponseDTO> sentenceDtos = topic.getSentences().stream()
                    .map(sentence -> {
                        DictationSentenceResponseDTO sentenceDto = new DictationSentenceResponseDTO();
                        sentenceDto.setId(sentence.getId());
                        sentenceDto.setAudioUrl(sentence.getAudioUrl());
                        sentenceDto.setOrderIndex(sentence.getOrderIndex());
                        return sentenceDto;
                    })
                    .collect(Collectors.toList());
            topicDto.setSentences(sentenceDtos);
        }
        return topicDto;
    }

    private DictationTopicResponseDTO convertToAdminDTO(DictationTopic topic) {
        DictationTopicResponseDTO topicDto = new DictationTopicResponseDTO();
        topicDto.setId(topic.getId());
        topicDto.setTitle(topic.getTitle());
        topicDto.setDescription(topic.getDescription());
        if (topic.getCategory() != null) {
            DictationTopicResponseDTO.CategoryInfoDTO catInfo = new DictationTopicResponseDTO.CategoryInfoDTO();
            catInfo.setId(topic.getCategory().getId());
            catInfo.setName(topic.getCategory().getName());
            topicDto.setCategory(catInfo);
        }
        topicDto.setCreatedAt(topic.getCreatedAt());
        topicDto.setUpdatedAt(topic.getUpdatedAt());
        topicDto.setCreatedBy(topic.getCreatedBy());
        topicDto.setUpdatedBy(topic.getUpdatedBy());

        List<DictationSentenceResponseDTO> sentenceDtos = topic.getSentences().stream()
                .map(sentence -> {
                    DictationSentenceResponseDTO sentenceDto = new DictationSentenceResponseDTO();
                    sentenceDto.setId(sentence.getId());
                    sentenceDto.setCorrectText(sentence.getCorrectText());
                    sentenceDto.setAudioUrl(sentence.getAudioUrl());
                    sentenceDto.setOrderIndex(sentence.getOrderIndex());
                    return sentenceDto;
                })
                .collect(Collectors.toList());

        topicDto.setSentences(sentenceDtos);
        return topicDto;
    }
}