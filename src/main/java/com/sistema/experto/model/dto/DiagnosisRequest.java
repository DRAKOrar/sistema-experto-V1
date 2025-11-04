package com.sistema.experto.model.dto;

import java.util.List;
public record DiagnosisRequest(String domainCode, List<AnswerDTO> answers) {}