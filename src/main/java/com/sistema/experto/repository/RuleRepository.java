package com.sistema.experto.repository;

import com.sistema.experto.model.Domain;
import com.sistema.experto.model.Rule;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RuleRepository extends JpaRepository<Rule, Long> {
    List<Rule> findByDomainOrderByPriorityAsc(Domain domain);
}