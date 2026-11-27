-- =====================================================================
-- SISTEMA ESCOLAR - MySQL
-- Script completo: criação do banco, tabelas, INSERT, UPDATE, DELETE e VIEWs
-- =====================================================================


-- =====================================================================
-- PASSO 2: CRIAR O BANCO DE DADOS E AS TABELAS
-- =====================================================================

-- 2.1 Criar o schema e selecionar para uso
DROP DATABASE IF EXISTS escola;
CREATE DATABASE escola DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE escola;

-- 2.2 Tabela PROFESSORES
CREATE TABLE professores (
    id_professor INT          NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    disciplina   VARCHAR(50)  NOT NULL,
    telefone     VARCHAR(15)  NULL,
    PRIMARY KEY (id_professor),
    UNIQUE KEY uq_professores_email (email)
);
DESCRIBE professores;

-- 2.3 Tabela TURMAS
CREATE TABLE turmas (
    id_turma INT         NOT NULL AUTO_INCREMENT,
    nome     VARCHAR(50) NOT NULL,
    serie    VARCHAR(20) NOT NULL,
    turno    VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_turma)
);
DESCRIBE turmas;

-- 2.4 Tabela ALUNOS (depende de turmas)
CREATE TABLE alunos (
    id_aluno             INT          NOT NULL AUTO_INCREMENT,
    nome                 VARCHAR(100) NOT NULL,
    data_nascimento      DATE         NOT NULL,
    responsavel          VARCHAR(100) NOT NULL,
    telefone_responsavel VARCHAR(15)  NULL,
    id_turma             INT          NOT NULL,
    PRIMARY KEY (id_aluno),
    CONSTRAINT fk_alunos_turmas
        FOREIGN KEY (id_turma) REFERENCES turmas (id_turma)
);
DESCRIBE alunos;

-- 2.5 Tabela PROFESSORES_TURMAS (N:N, chave primária composta)
CREATE TABLE professores_turmas (
    id_professor INT NOT NULL,
    id_turma     INT NOT NULL,
    PRIMARY KEY (id_professor, id_turma),
    CONSTRAINT fk_prof_turmas_professores
        FOREIGN KEY (id_professor) REFERENCES professores (id_professor),
    CONSTRAINT fk_prof_turmas_turmas
        FOREIGN KEY (id_turma) REFERENCES turmas (id_turma)
);
DESCRIBE professores_turmas;

SHOW TABLES;


-- =====================================================================
-- PASSO 3: INSERIR DADOS (INSERT)
-- =====================================================================

-- 3.1 Professores
INSERT INTO professores (nome, email, disciplina, telefone) VALUES
('Carlos Silva',  'carlos.silva@escola.com',  'Matemática',      '11987654321'),
('Maria Santos',  'maria.santos@escola.com',  'Português',       '11976543210'),
('João Oliveira', 'joao.oliveira@escola.com', 'História',        '11965432109'),
('Ana Costa',     'ana.costa@escola.com',     'Ciências',        '11954321098'),
('Paulo Lima',    'paulo.lima@escola.com',    'Educação Física', '11943210987');

SELECT * FROM professores;

-- 3.2 Turmas
INSERT INTO turmas (nome, serie, turno) VALUES
('6A', '6º ano', 'manhã'),
('7B', '7º ano', 'tarde'),
('8A', '8º ano', 'manhã'),
('9C', '9º ano', 'tarde');

SELECT * FROM turmas;

-- 3.3 Alunos (id_turma: 1=6A, 2=7B, 3=8A, 4=9C)
INSERT INTO alunos (nome, data_nascimento, responsavel, telefone_responsavel, id_turma) VALUES
('Pedro Alves',      '2010-03-15', 'Roberto Alves',    '11999887766', 1),
('Julia Mendes',     '2010-05-20', 'Carla Mendes',     '11988776655', 1),
('Lucas Rocha',      '2010-08-10', 'Fernanda Rocha',   '11977665544', 1),
('Beatriz Souza',    '2009-02-28', 'Marcos Souza',     '11966554433', 2),
('Gabriel Lima',     '2009-07-12', 'Patricia Lima',    '11955443322', 2),
('Mariana Costa',    '2009-11-05', 'José Costa',       '11944332211', 2),
('Rafael Santos',    '2008-01-18', 'Ana Santos',       '11933221100', 3),
('Larissa Oliveira', '2008-04-22', 'Paulo Oliveira',   '11922110099', 3),
('Felipe Martins',   '2008-09-30', 'Sandra Martins',   '11911009988', 3),
('Camila Ferreira',  '2008-12-15', 'Ricardo Ferreira', '11900998877', 3),
('Thiago Ribeiro',   '2007-03-08', 'Juliana Ribeiro',  '11899887766', 4),
('Amanda Silva',     '2007-06-25', 'Carlos Silva',     '11888776655', 4),
('Bruno Carvalho',   '2007-10-14', 'Marcia Carvalho',  '11877665544', 4),
('Isabela Gomes',    '2007-12-20', 'Fernando Gomes',   '11866554433', 4),
('Vitor Pereira',    '2008-02-11', 'Lucia Pereira',    '11855443322', 4);

SELECT COUNT(*) FROM alunos;  -- deve retornar 15

-- 3.4 Associar professores às turmas
INSERT INTO professores_turmas (id_professor, id_turma) VALUES
(1, 1),  -- Carlos (Matemática) na turma 6A
(2, 1),  -- Maria (Português) na turma 6A
(4, 1),  -- Ana (Ciências) na turma 6A
(1, 2),  -- Carlos (Matemática) na turma 7B
(2, 2),  -- Maria (Português) na turma 7B
(3, 2),  -- João (História) na turma 7B
(1, 3),  -- Carlos (Matemática) na turma 8A
(3, 3),  -- João (História) na turma 8A
(5, 3),  -- Paulo (Ed. Física) na turma 8A
(2, 4),  -- Maria (Português) na turma 9C
(3, 4),  -- João (História) na turma 9C
(4, 4);  -- Ana (Ciências) na turma 9C

SELECT * FROM professores_turmas;


-- =====================================================================
-- PASSO 4: ATUALIZAR DADOS (UPDATE)
-- =====================================================================

-- 4.1 Aluno Pedro (id=1) mudou para a turma 7B (id=2)
UPDATE alunos
SET id_turma = 2
WHERE id_aluno = 1;

SELECT nome, id_turma FROM alunos WHERE id_aluno = 1;

-- 4.2 Professor Carlos (id=1) atualizou o telefone
UPDATE professores
SET telefone = '11999999999'
WHERE id_professor = 1;

SELECT nome, telefone FROM professores WHERE id_professor = 1;

-- 4.3 Turma 8A (id=3) mudou de 'manhã' para 'tarde'
UPDATE turmas
SET turno = 'tarde'
WHERE id_turma = 3;

SELECT * FROM turmas WHERE id_turma = 3;


-- =====================================================================
-- PASSO 5: DELETAR DADOS (DELETE)
-- =====================================================================

-- 5.1 Remover o aluno Vitor (id=15), que se desmatriculou
DELETE FROM alunos
WHERE id_aluno = 15;

SELECT COUNT(*) FROM alunos;  -- deve retornar 14

-- 5.2 Remover a associação do professor Paulo (id=5) com a turma 8A (id=3)
DELETE FROM professores_turmas
WHERE id_professor = 5 AND id_turma = 3;

SELECT * FROM professores_turmas WHERE id_professor = 5;

-- 5.3 DESAFIO: tentar deletar a turma 6A (id=1)
-- Este comando gera ERRO de chave estrangeira (propositalmente), por isso
-- está comentado: assim o script completo roda sem parar.
-- Para ver o erro, tire os "-- " da linha abaixo e execute só ela.
--
-- DELETE FROM turmas WHERE id_turma = 1;
--
-- Erro esperado: Error Code: 1451. Cannot delete or update a parent row:
-- a foreign key constraint fails.
--
-- RESPOSTA: Não foi possível deletar a turma porque existem alunos vinculados
-- a ela através da chave estrangeira. Para deletar a turma, seria necessário
-- primeiro remover ou realocar todos os alunos.


-- =====================================================================
-- PASSO 6: CRIAR VIEWS
-- =====================================================================

-- 6.1 Lista de alunos com a turma
CREATE VIEW vw_lista_alunos AS
SELECT
    t.nome  AS turma,
    t.serie AS serie,
    a.nome  AS aluno
FROM alunos a
INNER JOIN turmas t ON a.id_turma = t.id_turma
ORDER BY t.nome, a.nome;

SELECT * FROM vw_lista_alunos;

-- 6.2 Professores por turma
CREATE VIEW vw_professores_turmas AS
SELECT
    t.nome       AS turma,
    p.nome       AS professor,
    p.disciplina AS disciplina
FROM professores_turmas pt
INNER JOIN professores p ON pt.id_professor = p.id_professor
INNER JOIN turmas t      ON pt.id_turma     = t.id_turma
ORDER BY t.nome, p.nome;

SELECT * FROM vw_professores_turmas;

-- 6.3 Total de alunos por turma (LEFT JOIN para turmas sem alunos aparecerem com 0)
CREATE VIEW vw_total_alunos_turma AS
SELECT
    t.nome  AS turma,
    t.serie AS serie,
    t.turno AS turno,
    COUNT(a.id_aluno) AS total_alunos
FROM turmas t
LEFT JOIN alunos a ON a.id_turma = t.id_turma
GROUP BY t.id_turma, t.nome, t.serie, t.turno
ORDER BY t.nome;

SELECT * FROM vw_total_alunos_turma;

-- 6.4 Alunos menores de idade (idade calculada a partir da data de hoje)
CREATE VIEW vw_alunos_menores AS
SELECT
    a.nome AS aluno,
    a.data_nascimento,
    TIMESTAMPDIFF(YEAR, a.data_nascimento, CURDATE()) AS idade,
    a.responsavel,
    a.telefone_responsavel
FROM alunos a
WHERE TIMESTAMPDIFF(YEAR, a.data_nascimento, CURDATE()) < 18
ORDER BY a.nome;

SELECT * FROM vw_alunos_menores;
