package com.sistema.experto.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity @Table(name="domain")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Domain {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable=false, unique=true, length=50)
    private String code; // "SALUD", "VEHICULOS", etc.
    @Column(nullable=false, length=120)
    private String name;
}