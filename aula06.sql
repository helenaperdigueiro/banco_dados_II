-- Renata Leal
-- Nathalia Vieira
-- Giovani Silva
-- Romullo Cardoso
-- Helena Perdigueiro
-- Carolina Hakamada

-- 01
-- DELIMITER $$
-- CREATE FUNCTION faturas_por_cliente(idDoCliente tinyint, dataInicial date, dataFinal date)
-- RETURNS decimal(10,2) DETERMINISTIC
-- BEGIN
-- DECLARE total decimal(10,2);
-- SET total = (SELECT sum(valor_total) 
-- 				FROM faturas f
--                 INNER JOIN clientes c
--                 ON f.id_cliente = c.id
--                 WHERE c.id = idDoCliente);
-- RETURN total;
-- END $$
-- DELIMITER ;

DELIMITER $$
CREATE FUNCTION faturas_por_cliente(idDoCliente tinyint, dataInicial date, dataFinal date)
RETURNS decimal(10,2) DETERMINISTIC
BEGIN
DECLARE total decimal(10,2);
SET total = (SELECT sum(valor_total) 
				FROM faturas f
                INNER JOIN clientes c
                ON f.id_cliente = c.id
                WHERE c.id = idDoCliente
                AND f.data_fatura BETWEEN dataInicial AND dataFinal);
RETURN total;
END $$
DELIMITER ;

SELECT faturas_por_cliente(1, '2021-02-01', '2021-02-01');

DELIMITER $$
CREATE PROCEDURE cliente_faturamento(dataInicial date, dataFinal date)
BEGIN
SELECT c.id, c.nome, c.sobrenome, IF(faturas_por_cliente(c.id, dataInicial, dataFinal) = 0 OR faturas_por_cliente(c.id, dataInicial, dataFinal) IS null, "Sem dados", faturas_por_cliente(c.id, dataInicial, dataFinal)) AS totalFaturas
FROM clientes c;
END $$
DELIMITER ;

CALL cliente_faturamento('2010-02-12', '2010-02-12');

-- janete:
DELIMITER $$
CREATE FUNCTION `faturas_por_cliente` (cliente_id INT, de DATE, ate DATE)
RETURNS DOUBLE DETERMINISTIC
BEGIN
	RETURN (SELECT SUM(valor_total) FROM faturas WHERE id_cliente = cliente_id AND data_fatura BETWEEN de AND ate);
END$$









