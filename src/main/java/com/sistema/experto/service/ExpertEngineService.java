package com.sistema.experto.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sistema.experto.model.Domain;
import com.sistema.experto.model.Rule;
import com.sistema.experto.model.dto.*;
import com.sistema.experto.repository.DomainRepository;
import com.sistema.experto.repository.OptionRepository;
import com.sistema.experto.repository.QuestionRepository;
import com.sistema.experto.repository.RuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;

// ExpertEngineService.java (fragmento)
@Service
@RequiredArgsConstructor
public class ExpertEngineService {

    private final DomainRepository domainRepo;
    private final QuestionRepository questionRepo;
    private final OptionRepository optionRepo;
    private final RuleRepository ruleRepo;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public DiagnosisResponse diagnose(DiagnosisRequest req, boolean withTrace) {
        Domain domain = domainRepo.findByCodeIgnoreCase(req.domainCode());
        if (domain == null) throw new IllegalArgumentException("Domain not found: " + req.domainCode());

        // mapa de respuestas: questionId -> optionValue
        Map<Long, String> answers = new HashMap<>();
        req.answers().forEach(a -> answers.put(a.questionId(), a.optionValue()));

        List<Rule> rules = ruleRepo.findByDomainOrderByPriorityAsc(domain);

        // Acumular CF por diagnóstico (si coinciden varias reglas con el mismo diagnóstico)
        Map<String, Double> cfByDiagnosis = new HashMap<>();
        Map<String, String> firstRuleByDiagnosis = new HashMap<>();
        Map<String, Integer> bestPriorityByDiagnosis = new HashMap<>();

        List<TraceItem> trace = new ArrayList<>();

        for (Rule r : rules) {
            boolean matched = safeMatch(r.getConditionsJson(), answers, trace, withTrace, r.getName());
            if (withTrace && !matched) {
                // ya se agregó un TraceItem dentro de safeMatch con reason
            }
            if (matched) {
                double current = cfByDiagnosis.getOrDefault(r.getDiagnosis(), 0.0);
                double combined = current + r.getCertainty() * (1 - current); // CF_comb = CF1 + CF2*(1-CF1)
                cfByDiagnosis.put(r.getDiagnosis(), combined);

                // guardar regla/priority “representativa” (la de mejor prioridad)
                int p = r.getPriority();
                int best = bestPriorityByDiagnosis.getOrDefault(r.getDiagnosis(), Integer.MAX_VALUE);
                if (!firstRuleByDiagnosis.containsKey(r.getDiagnosis()) || p < best) {
                    firstRuleByDiagnosis.put(r.getDiagnosis(), r.getName());
                    bestPriorityByDiagnosis.put(r.getDiagnosis(), p);
                }

                if (withTrace) {
                    trace.add(new TraceItem(r.getName(), true, r.getCertainty(), "Regla satisfecha"));
                }
            }
        }

        if (cfByDiagnosis.isEmpty()) {
            return new DiagnosisResponse(
                    req.domainCode(),
                    "No hay una coincidencia exacta. Revisa conexiones/entradas; si persiste, consulta un especialista.",
                    "NO_MATCH",
                    0.0,
                    withTrace ? trace : null
            );
        }

        // elegir el diagnóstico con mayor CF (empate: el de mejor prioridad)
        String chosenDiagnosis = null;
        double bestCf = -1.0;
        int chosenPriority = Integer.MAX_VALUE;

        for (var e : cfByDiagnosis.entrySet()) {
            String diag = e.getKey(); double cf = e.getValue();
            int prio = bestPriorityByDiagnosis.get(diag);
            if (cf > bestCf || (cf == bestCf && prio < chosenPriority)) {
                bestCf = cf; chosenDiagnosis = diag; chosenPriority = prio;
            }
        }

        String ruleName = firstRuleByDiagnosis.getOrDefault(chosenDiagnosis, "MULTIPLE_RULES");
        return new DiagnosisResponse(req.domainCode(), chosenDiagnosis, ruleName, bestCf, withTrace ? trace : null);
    }

    // Soporta:
    // - Array = AND de condiciones simples
    // - Objeto con {"all":[...], "any":[...]} (ambos opcionales, anidable)
    private boolean safeMatch(String json, Map<Long,String> answers, List<TraceItem> trace, boolean withTrace, String ruleName) {
        try {
            JsonNode node = objectMapper.readTree(json);
            boolean ok = matchesNode(node, answers);
            if (withTrace && !ok) trace.add(new TraceItem(ruleName, false, null, "No cumplen todas las condiciones"));
            return ok;
        } catch (Exception e) {
            if (withTrace) trace.add(new TraceItem(ruleName, false, null, "JSON inválido en conditions_json"));
            return false;
        }
    }

    private boolean matchesNode(JsonNode node, Map<Long,String> answers) {
        if (node == null || node.isNull()) return true;

        if (node.isArray()) {
            // AND de condiciones simples
            for (JsonNode c : node) {
                if (!matchesLeaf(c, answers)) return false;
            }
            return true;
        }

        if (node.isObject()) {
            boolean allOk = true, anyOk = false;
            if (node.has("all")) {
                JsonNode all = node.get("all");
                if (all != null) {
                    for (JsonNode c : all) {
                        if (!matchesNode(c, answers)) { allOk = false; break; }
                    }
                }
            }
            if (node.has("any")) {
                JsonNode any = node.get("any");
                if (any != null) {
                    for (JsonNode c : any) {
                        if (matchesNode(c, answers)) { anyOk = true; break; }
                    }
                } else {
                    anyOk = true; // si no hay any, no bloquea
                }
            } else {
                anyOk = true; // si no se especifica, se considera neutro
            }
            return allOk && anyOk;
        }

        // Otro tipo → no bloquea
        return true;
    }

    // Hoja: {"questionId": N, "optionValue":"SI"}
    private boolean matchesLeaf(JsonNode leaf, Map<Long,String> answers) {
        if (leaf == null || !leaf.isObject()) return true;
        JsonNode qid = leaf.get("questionId");
        JsonNode val = leaf.get("optionValue");
        if (qid == null || val == null) return true;
        long id = qid.asLong();
        String expected = val.asText(null);
        String given = answers.get(id);
        return Objects.equals(expected, given);
    }

    public List<QuestionDTO> getQuestions(String domainCode) {
        Domain domain = domainRepo.findByCodeIgnoreCase(domainCode);
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
}
