package com.sistema.experto.model;

import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name="question")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Question {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional=false) @JoinColumn(name="domain_id")
    private Domain domain;
    @Column(nullable=false, length=300)
    private String text;
    @Column(name="sort_order", nullable=false)
    private int sortOrder; // 1..6
}