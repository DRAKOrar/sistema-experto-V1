package com.sistema.experto.model;

import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name="option")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Option {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional=false) @JoinColumn(name="question_id")
    private Question question;
    @Column(nullable=false, length=120)
    private String text;   // etiqueta de botón
    @Column(length=60)
    private String value;  // código corto, ej: "SI", "NO", "ALTA", "BAJA"
}