package com.sistema.experto.model.dto;

import java.util.List;

public record DiagnosisResponse(
        String domainCode,
        String diagnosis,
        String ruleMatched,       // nombre de la regla principal (o la de mayor aporte)
        Double certainty,         // 0..1
        List<TraceItem> trace     // null si no se pidió traza
) {}