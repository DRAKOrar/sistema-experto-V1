package com.sistema.experto.repository;

import com.sistema.experto.model.Domain;
import com.sistema.experto.model.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {
    List<Question> findByDomainOrderBySortOrderAsc(Domain domain);
}
