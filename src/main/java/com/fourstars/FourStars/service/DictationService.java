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

    // ========================================================================
    // 1. ADMIN - CRUD OPERATIONS (Giữ nguyên logic chuẩn)
    // ========================================================================

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
        return convertToAdminDTO(updatedTopic);
    }

    @Transactional
    public void deleteDictationTopic(long topicId) {
        if (!topicRepository.existsById(topicId)) {
            throw new ResourceNotFoundException("Dictation topic not found with id: " + topicId);
        }
        topicRepository.deleteById(topicId);
    }

    @Transactional(readOnly = true)
    public DictationTopicResponseDTO getDictationTopicById(long topicId) {
        DictationTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation topic not found with id: " + topicId));
        return convertToAdminDTO(topic);
    }

    @Transactional(readOnly = true)
    public ResultPaginationDTO<DictationTopicResponseDTO> fetchAllTopics(
            Pageable pageable, Long categoryId, String title, LocalDate startCreatedAt, LocalDate endCreatedAt) {
        
        Specification<DictationTopic> spec = buildSpecification(categoryId, title, startCreatedAt, endCreatedAt);
        Page<DictationTopic> topicPage = topicRepository.findAll(spec, pageable);

        List<DictationTopicResponseDTO> dtoList = topicPage.getContent().stream()
                .map(this::convertToAdminDTO)
                .collect(Collectors.toList());

        return createPaginationResult(topicPage, dtoList);
    }

    // ========================================================================
    // 2. USER - OPERATIONS
    // ========================================================================

    @Transactional(readOnly = true)
    public ResultPaginationDTO<DictationTopicResponseDTO> fetchAllTopicsForUser(
            Pageable pageable, Long categoryId, String title, LocalDate startCreatedAt, LocalDate endCreatedAt) {
        
        Specification<DictationTopic> spec = buildSpecification(categoryId, title, startCreatedAt, endCreatedAt);
        Page<DictationTopic> topicPage = topicRepository.findAll(spec, pageable);

        List<DictationTopicResponseDTO> dtoList = topicPage.getContent().stream()
                .map(topic -> convertToUserResponseDTO(topic, false))
                .collect(Collectors.toList());

        return createPaginationResult(topicPage, dtoList);
    }

    @Transactional(readOnly = true)
    public DictationTopicResponseDTO getDictationTopicForUser(long topicId) {
        DictationTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("Dictation topic not found with id: " + topicId));
        return convertToAdminDTO(topic);
    }

    // ========================================================================
    // 3. SCORING LOGIC (Levenshtein Distance) - PHẦN QUAN TRỌNG NHẤT
    // ========================================================================

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

        // Nếu người dùng không nhập gì hoặc chỉ nhập khoảng trắng
        if (userText == null || userText.trim().isEmpty()) {
            response.setScore(0);
            return response;
        }

        // 1. Chuẩn hóa chuỗi
        String normCorrect = normalizeText(correctText);
        String normUser = normalizeText(userText);

        if (normCorrect.isEmpty()) {
            response.setScore(normUser.isEmpty() ? 100 : 0);
            return response;
        }

        // 2. Tính khoảng cách Levenshtein (Số bước chỉnh sửa để biến chuỗi A thành B)
        int distance = calculateLevenshteinDistance(normCorrect, normUser);

        // 3. Tính điểm phần trăm
        // Công thức: Similarity = 1 - (distance / max_length)
        int maxLength = Math.max(normCorrect.length(), normUser.length());
        double similarity = 1.0 - ((double) distance / maxLength);

        // Làm tròn điểm (ví dụ: 0.905 -> 91)
        int score = (int) Math.round(similarity * 100);
        
        // Chặn điểm tối thiểu là 0
        response.setScore(Math.max(0, score));

        // TODO: Phần này sau này bạn có thể tích hợp thư viện diff-match-patch để trả về array 'diffs' 
        // cho frontend tô màu xanh đỏ chi tiết từng từ.
        
        return response;
    }

    // --- Helper Methods cho thuật toán ---

    private String normalizeText(String text) {
        if (text == null) return "";
        // Chuyển thường, bỏ dấu câu (giữ lại chữ cái và số bất kể ngôn ngữ - Unicode safe)
        // Regex: \P{L} match mọi thứ KHÔNG PHẢI chữ cái (Letter), \P{N} match KHÔNG PHẢI số
        // Nhưng để đơn giản cho tiếng Anh, dùng regex cũ của bạn cũng ổn. 
        // Dưới đây là bản nâng cấp để hỗ trợ tiếng Việt nếu cần:
        // return text.toLowerCase().replaceAll("[^\\p{L}\\p{N}\\s]", "").replaceAll("\\s+", " ").trim();
        
        // Bản hiện tại (tốt cho tiếng Anh):
        return text.toLowerCase()
                   .replaceAll("[^a-zA-Z0-9\\s]", "") // Bỏ ký tự đặc biệt
                   .replaceAll("\\s+", " ")           // Gộp nhiều khoảng trắng
                   .trim();
    }

    private int calculateLevenshteinDistance(String s1, String s2) {
        int[][]dp = new int[s1.length() + 1][s2.length() + 1];

        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    int cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;
                    dp[i][j] = min(dp[i - 1][j] + 1,       // Deletion
                                   dp[i][j - 1] + 1,       // Insertion
                                   dp[i - 1][j - 1] + cost); // Substitution
                }
            }
        }
        return dp[s1.length()][s2.length()];
    }

    private int min(int a, int b, int c) {
        return Math.min(Math.min(a, b), c);
    }

    // ========================================================================
    // 4. UTILS & CONVERTERS
    // ========================================================================

    private Specification<DictationTopic> buildSpecification(Long categoryId, String title, LocalDate start, LocalDate end) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (categoryId != null) {
                predicates.add(criteriaBuilder.equal(root.get("category").get("id"), categoryId));
            }
            if (title != null && !title.trim().isEmpty()) {
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("title")), "%" + title.trim().toLowerCase() + "%"));
            }
            if (start != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"), start.atStartOfDay(ZoneId.systemDefault()).toInstant()));
            }
            if (end != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"), end.atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant()));
            }
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }

    private ResultPaginationDTO<DictationTopicResponseDTO> createPaginationResult(Page<DictationTopic> page, List<DictationTopicResponseDTO> dtos) {
        ResultPaginationDTO.Meta meta = new ResultPaginationDTO.Meta(
                page.getNumber() + 1, page.getSize(), page.getTotalPages(), page.getTotalElements());
        return new ResultPaginationDTO<>(meta, dtos);
    }

    private DictationTopicResponseDTO convertToUserResponseDTO(DictationTopic topic, boolean includeSentences) {
        DictationTopicResponseDTO topicDto = new DictationTopicResponseDTO();
        mapCommonFields(topic, topicDto);
        
        if (includeSentences) {
            topicDto.setSentences(topic.getSentences().stream().map(s -> {
                DictationSentenceResponseDTO dto = new DictationSentenceResponseDTO();
                dto.setId(s.getId());
                dto.setAudioUrl(s.getAudioUrl());
                dto.setOrderIndex(s.getOrderIndex());
                return dto;
            }).collect(Collectors.toList()));
        }
        return topicDto;
    }

    private DictationTopicResponseDTO convertToAdminDTO(DictationTopic topic) {
        DictationTopicResponseDTO topicDto = new DictationTopicResponseDTO();
        mapCommonFields(topic, topicDto);

        topicDto.setSentences(topic.getSentences().stream().map(s -> {
            DictationSentenceResponseDTO dto = new DictationSentenceResponseDTO();
            dto.setId(s.getId());
            dto.setCorrectText(s.getCorrectText()); // Admin thấy được text đúng
            dto.setAudioUrl(s.getAudioUrl());
            dto.setOrderIndex(s.getOrderIndex());
            return dto;
        }).collect(Collectors.toList()));
        
        return topicDto;
    }

    private void mapCommonFields(DictationTopic source, DictationTopicResponseDTO target) {
        target.setId(source.getId());
        target.setTitle(source.getTitle());
        target.setDescription(source.getDescription());
        if (source.getCategory() != null) {
            DictationTopicResponseDTO.CategoryInfoDTO catInfo = new DictationTopicResponseDTO.CategoryInfoDTO();
            catInfo.setId(source.getCategory().getId());
            catInfo.setName(source.getCategory().getName());
            target.setCategory(catInfo);
        }
        target.setCreatedAt(source.getCreatedAt());
        target.setUpdatedAt(source.getUpdatedAt());
        target.setCreatedBy(source.getCreatedBy());
        target.setUpdatedBy(source.getUpdatedBy());
    }
}