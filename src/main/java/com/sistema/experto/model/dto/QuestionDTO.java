package com.sistema.experto.model.dto;

import java.util.List;
public record QuestionDTO(Long id, String text, int order, List<OptionDTO> options) {}