package com.sistema.experto.repository;

import com.sistema.experto.model.Domain;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DomainRepository extends JpaRepository<Domain, Long> {
    Domain findByCode(String code);
}
