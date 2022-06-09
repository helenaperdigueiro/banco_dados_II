DELIMITER $$

CREATE FUNCTION fn_total(a decimal(10,2), b int)
RETURNS decimal(10,2) DETERMINISTIC
BEGIN
RETURN a * b;
END $$
DELIMITER ;

SELECT fn_total(2.5, 4);

SELECT p.ProdutoNome, d.PrecoUnitario, d.Quantidade, fn_total(d.PrecoUnitario, d.Quantidade) AS ValorVenda
FROM produtos p
INNER JOIN detalhefatura d
ON p.ProdutoID = d.ProdutoID
ORDER BY valorVenda DESC;

DELIMITER $$
CREATE FUNCTION calcula_idade(dataNasc date)
RETURNS int DETERMINISTIC
BEGIN
DECLARE resultado int;
SET resultado = (SELECT timestampdiff(YEAR, dataNasc, curdate()));
RETURN resultado;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE listarIdade(IN getIdade int)
BEGIN
SELECT nome, sobrenome, calcula_idade(DataNascimento) AS Idade
FROM empregados
WHERE calcula_idade(DataNascimento) = getIdade;
END $$
DELIMITER ;

CALL listarIdade(58);

-- mesa
-- 01
DELIMITER $$
CREATE FUNCTION getIdade(dataNasc date)
RETURNS tinyint DETERMINISTIC
BEGIN
DECLARE resultado tinyint;
SET resultado = (SELECT timestampdiff(YEAR, dataNasc, curdate()));
RETURN resultado;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE empregadoIdade()
BEGIN
SELECT nome, sobrenome, getIdade(DataNascimento) AS idade
FROM empregados
ORDER BY nome;
END $$
DELIMITER ;

CALL empregadoIdade();

-- 02
DELIMITER $$
CREATE PROCEDURE retornar_cidade(IN localizacao varchar(30))
BEGIN
SELECT Nome, Sobrenome, getIdade(DataNascimento) AS Idade, Cidade
FROM empregados
WHERE Cidade = localizacao AND getIdade(DataNascimento) > 25;
END $$
DELIMITER ;

CALL retornar_cidade('London');

-- 03
DELIMITER $$
CREATE PROCEDURE diferencaIdade()
BEGIN
DECLARE idadeMaxima tinyint;
SET idadeMaxima = (SELECT max(getIdade(DataNascimento)) FROM empregados);
SELECT nome, sobrenome, getIdade(DataNascimento) AS idade, idadeMaxima - getIdade(DataNascimento) AS diferenca
FROM empregados;
END $$
DELIMITER ;

CALL diferencaIdade();

-- 04
DELIMITER $$
CREATE FUNCTION aplicar_aumento(preco decimal(10,2), porcentagem decimal(3,2))
RETURNS decimal(10,2) DETERMINISTIC
BEGIN
DECLARE resultado decimal(10,2);
SET resultado = preco + (preco * porcentagem);
RETURN resultado;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE validaPreco(desct decimal(3,2))
BEGIN
SELECT p.produtoNome, c.empresa, df.PrecoUnitario, df.desconto, aplicar_aumento(df.PrecoUnitario, df.desconto) AS novoPreco
FROM detalhefatura df
INNER JOIN faturas f
ON df.FaturaId = f.FaturaId
INNER JOIN clientes c
ON f.ClienteID = c.ClienteID
INNER JOIN produtos p
ON df.ProdutoID = p.ProdutoID
WHERE df.Desconto >= desct;
END $$
DELIMITER ;

CALL validaPreco(0.25);


-- mesa
DELIMITER $$
CREATE FUNCTION calcular_idade(dataNasc date)
RETURNS tinyint DETERMINISTIC
BEGIN
DECLARE idade tinyint;
SET idade = (SELECT timestampdiff(YEAR, dataNasc, curdate()));
RETURN idade;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE atualizar_idade()
BEGIN
SELECT e.nome, e.sobrenome, e.data_nascimento, calcular_idade(e.data_nascimento) AS idade
FROM empregados e;
END $$
DELIMITER ;

CALL atualizar_idade();


-- Renata Leal
-- Nathalia Vieira
-- Giovani Silva
-- Romullo Cardoso
-- Helena Perdigueiro