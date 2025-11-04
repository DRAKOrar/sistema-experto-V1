package com.sistema.experto.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity @Table(name="rule")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Rule {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional=false) @JoinColumn(name="domain_id")
    private Domain domain;
    @Column(nullable=false, length=120)
    private String name; // etiqueta de la regla
    /**
     * conditions_json = arreglo de objetos:
     * [ {"questionId":1,"optionValue":"SI"}, {"questionId":3,"optionValue":"ALTA"} ]
     * La regla hace match si TODAS las condiciones se cumplen.
     */
    @Column(name="conditions_json", columnDefinition = "jsonb", nullable=false)
    private String conditionsJson;
    @Column(nullable=false, length=300)
    private String diagnosis;
    @Column(nullable=false)
    private int priority; // menor número = más prioridad

    // Nuevo: factor de certeza 0..1 (por defecto 1.0)
    @Column(nullable=false, columnDefinition = "numeric(3,2) default 1.0")
    private double certainty = 1.0;
}