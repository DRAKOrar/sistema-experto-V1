package com.sistema.experto.model.dto;

public record TraceItem(
        String ruleName,
        boolean matched,
        Double certaintyContribution, // null si no hizo match
        String reason                  // breve explicación
) {}