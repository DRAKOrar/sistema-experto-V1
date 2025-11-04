package com.sistema.experto.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sistema.experto.model.Domain;
import com.sistema.experto.model.Rule;
import com.sistema.experto.model.dto.DiagnosisRequest;
import com.sistema.experto.model.dto.DiagnosisResponse;
import com.sistema.experto.model.dto.OptionDTO;
import com.sistema.experto.model.dto.QuestionDTO;
import com.sistema.experto.repository.DomainRepository;
import com.sistema.experto.repository.OptionRepository;
import com.sistema.experto.repository.QuestionRepository;
import com.sistema.experto.repository.RuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ExpertEngineService {

    private final DomainRepository domainRepo;
    private final QuestionRepository questionRepo;
    private final OptionRepository optionRepo;
    private final RuleRepository ruleRepo;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public List<QuestionDTO> getQuestions(String domainCode) {
        Domain domain = domainRepo.findByCode(domainCode);
        if (domain == null) throw new IllegalArgumentException("Domain not found: " + domainCode);
        var questions = questionRepo.findByDomainOrderBySortOrderAsc(domain);
        List<QuestionDTO> result = new ArrayList<>();
        for (var q : questions) {
            var options = optionRepo.findByQuestionIdOrderByIdAsc(q.getId())
                    .stream().map(o -> new OptionDTO(o.getId(), o.getText(), o.getValue())).toList();
            result.add(new QuestionDTO(q.getId(), q.getText(), q.getSortOrder(), options));
        }
        return result;
    }

    public DiagnosisResponse diagnose(DiagnosisRequest req) {
        Domain domain = domainRepo.findByCode(req.domainCode());
        if (domain == null) throw new IllegalArgumentException("Domain not found: " + req.domainCode());

        Map<Long,String> answersMap = new HashMap<>();
        req.answers().forEach(a -> answersMap.put(a.questionId(), a.optionValue()));

        for (Rule rule : ruleRepo.findByDomainOrderByPriorityAsc(domain)) {
            if (matches(rule.getConditionsJson(), answersMap)) {
                return new DiagnosisResponse(req.domainCode(), rule.getDiagnosis(), rule.getName());
            }
        }
        return new DiagnosisResponse(req.domainCode(),
                "No hay una coincidencia exacta. Recomendación: consulte un profesional o refine sus respuestas.",
                "NO_MATCH");
    }

    private boolean matches(String conditionsJson, Map<Long,String> answers) {
        try {
            List<Map<String, Object>> conditions = objectMapper.readValue(
                    conditionsJson, new TypeReference<>() {});
            for (var cond : conditions) {
                Long qid = ((Number)cond.get("questionId")).longValue();
                String expected = Objects.toString(cond.get("optionValue"), null);
                String given = answers.get(qid);
                if (!Objects.equals(expected, given)) return false;
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}