-- Consultas Analíticas para o Sistema de Clínica Médica
USE clinica_medica;

-- 1. Contagem de consultas por especialidade e por médico no último ano
SELECT
    E.nome_especialidade,
    M.nome AS nome_medico,
    COUNT(C.id_consulta) AS total_consultas
FROM Consultas C
JOIN Especialidades E ON C.especialidade_id = E.id_especialidade
JOIN Medicos M ON C.medico_id = M.id_medico
WHERE C.data_hora >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY E.nome_especialidade, M.nome
ORDER BY total_consultas DESC;

-- 2. Pacientes com mais de 5 agendamentos ou consultas no total, mostrando o histórico
SELECT
    P.nome AS nome_paciente,
    P.cpf,
    COUNT(DISTINCT C.id_consulta) AS total_consultas,
    COUNT(DISTINCT A.id_agendamento) AS total_agendamentos,
    GROUP_CONCAT(DISTINCT CONCAT('Consulta: ', DATE_FORMAT(C.data_hora, '%Y-%m-%d %H:%i'), ' com Dr. ', M_C.nome, ' (', E.nome_especialidade, ')') ORDER BY C.data_hora SEPARATOR '; ') AS historico_consultas,
    GROUP_CONCAT(DISTINCT CONCAT('Agendamento: ', DATE_FORMAT(A.data_hora_agendamento, '%Y-%m-%d %H:%i'), ' (', A.tipo_agendamento, ')') ORDER BY A.data_hora_agendamento SEPARATOR '; ') AS historico_agendamentos
FROM Pacientes P
LEFT JOIN Consultas C ON P.id_paciente = C.paciente_id
LEFT JOIN Medicos M_C ON C.medico_id = M_C.id_medico
LEFT JOIN Especialidades E ON C.especialidade_id = E.id_especialidade
LEFT JOIN Agendamentos A ON P.id_paciente = A.paciente_id
GROUP BY P.id_paciente, P.nome, P.cpf
HAVING (COUNT(DISTINCT C.id_consulta) + COUNT(DISTINCT A.id_agendamento)) > 5
ORDER BY (total_consultas + total_agendamentos) DESC;

-- 3. Média de consultas por médico por mês no último semestre
SELECT
    M.nome AS nome_medico,
    DATE_FORMAT(C.data_hora, '%Y-%m') AS ano_mes,
    COUNT(C.id_consulta) AS consultas_no_mes,
    ROUND(COUNT(C.id_consulta) / 30.0, 2) AS media_diaria
FROM Consultas C
JOIN Medicos M ON C.medico_id = M.id_medico
WHERE C.data_hora >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY M.nome, ano_mes
ORDER BY media_diaria;

-- 4. Agendamentos futuros detalhados por médico
SELECT
    M.nome AS nome_medico,
    P.nome AS nome_paciente,
    A.data_hora_agendamento,
    A.tipo_agendamento,
    A.status
FROM Agendamentos A
JOIN Medicos M ON A.medico_id = M.id_medico
JOIN Pacientes P ON A.paciente_id = P.id_paciente
WHERE A.data_hora_agendamento > NOW()
ORDER BY M.nome, A.data_hora_agendamento;

-- 5. Distribuição de status de consultas por especialidade
SELECT
    E.nome_especialidade,
    C.status,
    COUNT(C.id_consulta) AS total_consultas
FROM Consultas C
JOIN Especialidades E ON C.especialidade_id = E.id_especialidade
GROUP BY E.nome_especialidade, C.status
ORDER BY E.nome_especialidade, total_consultas DESC;

-- 6. Médicos que não tiveram consultas nos últimos 3 meses
SELECT
    M.nome AS nome_medico,
    M.crm
FROM Medicos M
LEFT JOIN Consultas C ON M.id_medico = C.medico_id
WHERE C.id_consulta IS NULL OR C.data_hora < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY M.id_medico, M.nome, M.crm
HAVING MAX(C.data_hora) IS NULL OR MAX(C.data_hora) < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
ORDER BY M.nome;
