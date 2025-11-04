package com.sistema.experto.controller;

import com.sistema.experto.model.dto.DiagnosisRequest;
import com.sistema.experto.model.dto.DiagnosisResponse;
import com.sistema.experto.model.dto.QuestionDTO;
import com.sistema.experto.service.ExpertEngineService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/expert")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ExpertController {

    private final ExpertEngineService service;

    @GetMapping("/{domainCode}/questions")
    public ResponseEntity<List<QuestionDTO>> getQuestions(@PathVariable String domainCode) {
        return ResponseEntity.ok(service.getQuestions(domainCode));
    }

    @PostMapping("/diagnose")
    public ResponseEntity<DiagnosisResponse> diagnose(@RequestBody DiagnosisRequest request) {
        return ResponseEntity.ok(service.diagnose(request));
    }
}