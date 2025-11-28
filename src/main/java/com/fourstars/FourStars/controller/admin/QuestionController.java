package com.fourstars.FourStars.controller.admin;

import com.fourstars.FourStars.domain.request.question.QuestionDTO;
import com.fourstars.FourStars.service.QuestionService;
import com.fourstars.FourStars.util.annotation.ApiMessage;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/admin/questions")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
@Tag(name = "Admin - Question Management")
@CrossOrigin(origins = "http://localhost:5173", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PATCH, RequestMethod.PUT, RequestMethod.DELETE})
public class QuestionController {
    private final QuestionService questionService;

    @PostMapping
    @Operation(summary = "Create question") @ApiMessage("Create question")
    public ResponseEntity<QuestionDTO> create(@Valid @RequestBody QuestionDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(questionService.createQuestion(dto));
    }

    @PatchMapping("/{id}")
    @Operation(summary = "Update question") @ApiMessage("Update question")
    public ResponseEntity<QuestionDTO> update(@PathVariable long id, @Valid @RequestBody QuestionDTO dto) {
        return ResponseEntity.ok(questionService.updateQuestion(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete question") @ApiMessage("Delete question")
    public ResponseEntity<Void> delete(@PathVariable long id) {
        questionService.deleteQuestion(id);
        return ResponseEntity.noContent().build();
    }
}