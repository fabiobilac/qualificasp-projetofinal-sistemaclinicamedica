-- Preparando o ambiente para criação do Database.
DROP DATABASE IF EXISTS clinica_medica;

-- Criar a Database clinica_medica se não existir.
CREATE DATABASE IF NOT EXISTS clinica_medica
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Selecionando a database
USE clinica_medica;

/* Criação das tabelas: Pacientes, Medicos, Especialidades, Medico_Especialidade, Consultas e Agendamentos */

CREATE TABLE IF NOT EXISTS Pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Especialidades (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE IF NOT EXISTS Medico_Especialidade (
    medico_id INT NOT NULL,
    especialidade_id INT NOT NULL,
    PRIMARY KEY (medico_id, especialidade_id),
    FOREIGN KEY (medico_id) REFERENCES Medicos(id_medico) ON DELETE CASCADE,
    FOREIGN KEY (especialidade_id) REFERENCES Especialidades(id_especialidade) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    especialidade_id INT NOT NULL,
    data_hora DATETIME NOT NULL,
    observacoes TEXT,
    status VARCHAR(50) DEFAULT 'Agendada',
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (medico_id) REFERENCES Medicos(id_medico) ON DELETE CASCADE,
    FOREIGN KEY (especialidade_id) REFERENCES Especialidades(id_especialidade) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    data_hora_agendamento DATETIME NOT NULL,
    tipo_agendamento VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Confirmado',
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (medico_id) REFERENCES Medicos(id_medico) ON DELETE CASCADE
);
