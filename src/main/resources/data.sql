-- Dominios
INSERT INTO domain (id, code, name) VALUES
    (1, 'SALUD', 'Salud')
    ON CONFLICT DO NOTHING;

-- Preguntas SALUD (1..6)
INSERT INTO question (id, domain_id, text, sort_order) VALUES
                                                           (101, 1, '¿Tienes fiebre (≥38°C)?', 1),
                                                           (102, 1, '¿Presentas tos?', 2),
                                                           (103, 1, '¿Dificultad para respirar?', 3),
                                                           (104, 1, '¿Dolor de garganta?', 4),
                                                           (105, 1, '¿Dolor de cabeza o malestar general?', 5),
                                                           (106, 1, '¿Contacto reciente con persona enferma?', 6)
    ON CONFLICT DO NOTHING;

-- Opciones SALUD (botones simples SI/NO; puedes afinar por pregunta)
INSERT INTO option (question_id, text, value) VALUES
                                                  (101, 'Sí', 'SI'), (101, 'No', 'NO'),
                                                  (102, 'Sí', 'SI'), (102, 'No', 'NO'),
                                                  (103, 'Sí', 'SI'), (103, 'No', 'NO'),
                                                  (104, 'Sí', 'SI'), (104, 'No', 'NO'),
                                                  (105, 'Sí', 'SI'), (105, 'No', 'NO'),
                                                  (106, 'Sí', 'SI'), (106, 'No', 'NO');

-- Reglas SALUD (jsonb con condiciones exactas)
-- Regla 1: Sospecha COVID-19 (prioridad 1)
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (1,
        'SOSPECHA_COVID',
        '[
           {"questionId":101,"optionValue":"SI"},
           {"questionId":102,"optionValue":"SI"},
           {"questionId":106,"optionValue":"SI"}
         ]',
        'Posible infección respiratoria viral (p. ej., COVID-19 leve). Aíslese y consulte orientación médica.',
        1
       );

-- Regla 2: Cuadro respiratorio moderado (prioridad 2)
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (1,
        'RESP_MODERADO',
        '[
           {"questionId":101,"optionValue":"SI"},
           {"questionId":103,"optionValue":"SI"}
         ]',
        'Síntomas respiratorios que ameritan evaluación prioritaria (fiebre + disnea). Busque atención médica.',
        2
       );

-- Regla 3: Resfriado común (prioridad 3)
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (1,
        'RESFRIADO_COMUN',
        '[
           {"questionId":102,"optionValue":"SI"},
           {"questionId":104,"optionValue":"SI"},
           {"questionId":105,"optionValue":"SI"}
         ]',
        'Cuadro compatible con resfriado común. Hidratación, reposo y vigilancia de signos de alarma.',
        3
       );


-- Crear el dominio "VEHICULOS"
INSERT INTO domain (id, code, name) VALUES
    (2, 'VEHICULOS', 'Diagnóstico de Vehículos')
    ON CONFLICT DO NOTHING;

-- Preguntas para Vehículos
INSERT INTO question (id, domain_id, text, sort_order) VALUES
                                                           (201, 2, '¿Enciende el motor?', 1),
                                                           (202, 2, '¿Testigo de Check Engine activo?', 2),
                                                           (203, 2, '¿Escuchas ruidos metálicos?', 3),
                                                           (204, 2, '¿Pierde potencia el vehículo?', 4),
                                                           (205, 2, '¿Emite humo inusual?', 5),
                                                           (206, 2, '¿Hay fugas visibles de fluidos?', 6)
    ON CONFLICT DO NOTHING;

-- Opciones para Vehículos (Sí / No)
INSERT INTO option (question_id, text, value) VALUES
                                                  (201, 'Sí', 'SI'), (201, 'No', 'NO'),
                                                  (202, 'Sí', 'SI'), (202, 'No', 'NO'),
                                                  (203, 'Sí', 'SI'), (203, 'No', 'NO'),
                                                  (204, 'Sí', 'SI'), (204, 'No', 'NO'),
                                                  (205, 'Sí', 'SI'), (205, 'No', 'NO'),
                                                  (206, 'Sí', 'SI'), (206, 'No', 'NO');

-- Reglas para Vehículos
-- Regla 1: Posible problema con batería o alternador
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (2,
        'PROBLEMA_BATERIA',
        '[
           {"questionId":201,"optionValue":"NO"},
           {"questionId":202,"optionValue":"SI"}
         ]',
        'Posible problema con batería o alternador. Revisión urgente recomendada.',
        1
       );

-- Regla 2: Falla de bujías o bobina
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (2,
        'FALLA_BUJIAS',
        '[
           {"questionId":203,"optionValue":"SI"},
           {"questionId":204,"optionValue":"SI"}
         ]',
        'Posible falla de bujías o bobina. Reemplazo recomendado.',
        2
       );

-- Regla 3: Fuga de refrigerante
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (2,
        'FUGA_REFRIGERANTE',
        '[
           {"questionId":205,"optionValue":"SI"},
           {"questionId":206,"optionValue":"SI"}
         ]',
        'Posible fuga de refrigerante. Revisión y reparación urgente.',
        3
       );

-- Crear el dominio "MANTENIMIENTO"
INSERT INTO domain (id, code, name) VALUES
    (3, 'MANTENIMIENTO', 'Mantenimiento de Equipos')
    ON CONFLICT DO NOTHING;

-- Preguntas para Mantenimiento de Equipos
INSERT INTO question (id, domain_id, text, sort_order) VALUES
                                                           (301, 3, '¿El equipo enciende?', 1),
                                                           (302, 3, '¿Hace ruidos extraños?', 2),
                                                           (303, 3, '¿Se sobrecalienta?', 3),
                                                           (304, 3, '¿No responde al encender?', 4)
    ON CONFLICT DO NOTHING;

-- Opciones para Mantenimiento de Equipos (Sí / No)
INSERT INTO option (question_id, text, value) VALUES
                                                  (301, 'Sí', 'SI'), (301, 'No', 'NO'),
                                                  (302, 'Sí', 'SI'), (302, 'No', 'NO'),
                                                  (303, 'Sí', 'SI'), (303, 'No', 'NO'),
                                                  (304, 'Sí', 'SI'), (304, 'No', 'NO');

-- Reglas para Mantenimiento de Equipos
-- Regla 1: Problema con la fuente de alimentación
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (3,
        'PROBLEMA_ALIMENTACION',
        '[
           {"questionId":301,"optionValue":"NO"},
           {"questionId":304,"optionValue":"SI"}
         ]',
        'Posible problema con la fuente de alimentación. Revisar cables y fuente.',
        1
       );

-- Regla 2: Falla en el ventilador
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (3,
        'FALLA_VENTILADOR',
        '[
           {"questionId":302,"optionValue":"SI"},
           {"questionId":303,"optionValue":"SI"}
         ]',
        'Posible falla en el ventilador. Reemplazo recomendado.',
        2
       );

-- Crear el dominio "EDUCACION"
INSERT INTO domain (id, code, name) VALUES
    (4, 'EDUCACION', 'Diagnóstico de Educación')
    ON CONFLICT DO NOTHING;

-- Preguntas para Educación
INSERT INTO question (id, domain_id, text, sort_order) VALUES
                                                           (401, 4, '¿Tu calificación final fue mayor a 7?', 1),
                                                           (402, 4, '¿Asististe al 80% de las clases?', 2),
                                                           (403, 4, '¿Completaste todas las tareas asignadas?', 3),
                                                           (404, 4, '¿Participaste activamente en clase?', 4)
    ON CONFLICT DO NOTHING;

-- Opciones para Educación (Sí / No)
INSERT INTO option (question_id, text, value) VALUES
                                                  (401, 'Sí', 'SI'), (401, 'No', 'NO'),
                                                  (402, 'Sí', 'SI'), (402, 'No', 'NO'),
                                                  (403, 'Sí', 'SI'), (403, 'No', 'NO'),
                                                  (404, 'Sí', 'SI'), (404, 'No', 'NO');

-- Reglas para Educación
-- Regla 1: Estudiante Excelente
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (4,
        'ESTUDIANTE_EXCELENTE',
        '[
           {"questionId":401,"optionValue":"SI"},
           {"questionId":402,"optionValue":"SI"},
           {"questionId":403,"optionValue":"SI"},
           {"questionId":404,"optionValue":"SI"}
         ]',
        'Estudiante excelente. Continuar así.',
        1
       );

-- Regla 2: Estudiante con buen rendimiento
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (4,
        'BUEN_RENDIMIENTO',
        '[
           {"questionId":401,"optionValue":"SI"},
           {"questionId":402,"optionValue":"SI"},
           {"questionId":403,"optionValue":"SI"}
         ]',
        'Buen rendimiento. Necesitas mejorar en participación.',
        2
       );


-- =========================
-- DOMINIO: INTERNET
-- =========================
INSERT INTO domain (id, code, name) VALUES
    (5, 'INTERNET', 'Diagnóstico Conexión a Internet')
    ON CONFLICT DO NOTHING;

-- =========================
-- PREGUNTAS (10)
-- =========================
-- Nota: usamos SI/NO en todas para mantener botones simples
INSERT INTO question (id, domain_id, text, sort_order) VALUES
                                                           (501, 5, '¿No hay internet en general en tu red?', 1),                     -- no_hay_internet
                                                           (502, 5, '¿La señal Wi-Fi se ve correcta en los dispositivos?', 2),        -- wifi_ok
                                                           (503, 5, '¿Los cables del router/modem están bien conectados?', 3),        -- cable_ok
                                                           (504, 5, '¿Alguna luz del router está roja o parpadea anormal?', 4),       -- luz_router_roja
                                                           (505, 5, '¿Solo un dispositivo está sin internet?', 5),                     -- solo_un_dispositivo_sin_internet
                                                           (506, 5, '¿Tienes pago vencido con el proveedor?', 6),                      -- pago_vencido
                                                           (507, 5, '¿El ping al gateway (puerta de enlace) falla?', 7),               -- ping_gateway_falla
                                                           (508, 5, '¿El ping al router local responde?', 8),                          -- ping_router_ok
                                                           (509, 5, '¿El DNS no responde?', 9),                                        -- dns_no_responde
                                                           (510, 5, '¿Ya reiniciaste el router y persiste sin internet?', 10);         -- reiniciar_router + persiste

-- Opciones SI/NO para cada pregunta
INSERT INTO option (question_id, text, value) VALUES
                                                  (501,'Sí','SI'),(501,'No','NO'),
                                                  (502,'Sí','SI'),(502,'No','NO'),
                                                  (503,'Sí','SI'),(503,'No','NO'),
                                                  (504,'Sí','SI'),(504,'No','NO'),
                                                  (505,'Sí','SI'),(505,'No','NO'),
                                                  (506,'Sí','SI'),(506,'No','NO'),
                                                  (507,'Sí','SI'),(507,'No','NO'),
                                                  (508,'Sí','SI'),(508,'No','NO'),
                                                  (509,'Sí','SI'),(509,'No','NO'),
                                                  (510,'Sí','SI'),(510,'No','NO');

-- =========================
-- REGLAS (prioridad: menor = primero)
-- =========================

-- R3: SOLO UN DISPOSITIVO SIN INTERNET → problema del dispositivo
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'PROBLEMA_DISPOSITIVO',
        '[
          {"questionId":505,"optionValue":"SI"}
        ]',
        'Parece un problema del dispositivo específico (Wi-Fi desactivado, IP, drivers). Revisa ese equipo primero.',
        1);

-- R4: NO HAY INTERNET ∧ PAGO VENCIDO → regularizar pago
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'REGULARIZAR_PAGO',
        '[
          {"questionId":501,"optionValue":"SI"},
          {"questionId":506,"optionValue":"SI"}
        ]',
        'El servicio aparece sin conexión y hay pago vencido. Regulariza el pago con el proveedor.',
        2);

-- R6: PING AL ROUTER FALLA → revisar cables router (si falla router, a veces 508=NO; aquí cubrimos falla directa al router)
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'REVISAR_CABLES_ROUTER',
        '[
          {"questionId":508,"optionValue":"NO"}
        ]',
        'El router no responde. Revisa cables de energía/red y puertos del router/modem.',
        3);

-- R1: NO HAY INTERNET ∧ WIFI OK ∧ CABLE OK → reiniciar router
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'REINICIAR_ROUTER',
        '[
          {"questionId":501,"optionValue":"SI"},
          {"questionId":502,"optionValue":"SI"},
          {"questionId":503,"optionValue":"SI"}
        ]',
        'Acción sugerida: reinicia el router/modem (apagar/encender). Espera 1–2 minutos y verifica.',
        4);

-- R7: Reiniciado y persiste sin internet → escalar a proveedor
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'ESCALAR_TRAS_REINICIO',
        '[
          {"questionId":510,"optionValue":"SI"}
        ]',
        'Tras reinicio persiste la falla. Escala el caso al proveedor (línea externa/ONT).',
        5);

-- R2’ (parte 1 de OR): LUZ ROJA → escalar proveedor
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'ESCALAR_LUZ_ROJA',
        '[
          {"questionId":504,"optionValue":"SI"}
        ]',
        'Indicador de falla en el enlace. Escala al proveedor para revisión de línea/ONT.',
        6);

-- R2’ (parte 2 de OR): PING GATEWAY FALLA → escalar proveedor
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'ESCALAR_GATEWAY',
        '[
          {"questionId":507,"optionValue":"SI"}
        ]',
        'No hay llegada al gateway. Posible falla del proveedor. Escala soporte técnico.',
        7);

-- R5 (del doc): PING GATEWAY FALLA ∧ PING ROUTER OK → posible falla proveedor
-- (Más específico que el anterior; lo ponemos con prioridad un poco más alta)
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'PROVEEDOR_GATEWAY_SIN_RESPUESTA',
        '[
          {"questionId":507,"optionValue":"SI"},
          {"questionId":508,"optionValue":"SI"}
        ]',
        'El router responde pero el gateway no. Alta probabilidad de incidente del proveedor. Escalar.',
        8);

-- R8: DNS NO RESPONDE ∧ OTROS SERVICIOS OK → configurar DNS alternativo
-- Modelamos "otros servicios ok" como: hay internet general = NO, no aplica; mejor: router OK y gateway OK
-- Para simplificar: si DNS no responde pero router y gateway responden, sugiere cambiar DNS.
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'CONFIGURAR_DNS_ALTERNATIVO',
        '[
          {"questionId":509,"optionValue":"SI"},
          {"questionId":508,"optionValue":"SI"},
          {"questionId":507,"optionValue":"NO"}
        ]',
        'El DNS parece fallar. Prueba configurar DNS alternativo (por ej., 1.1.1.1 o 8.8.8.8) en tu router o equipo.',
        9);

-- Fallback
INSERT INTO rule (domain_id, name, conditions_json, diagnosis, priority)
VALUES (5,'SIN_MATCH',
        '[]',
        'No hay una coincidencia exacta. Revisa cables, reinicia el router y contacta al proveedor si persiste.',
        99);

