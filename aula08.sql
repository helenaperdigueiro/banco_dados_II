-- cursor

DELIMITER $$
CREATE PROCEDURE criarLista(INOUT listaEmail varchar(4000))
BEGIN
DECLARE fim int default 0;
DECLARE endEmail varchar(100) default '';

DECLARE curEmail
CURSOR FOR SELECT email FROM clientes;

DECLARE continue handler for NOT FOUND SET fim = 1;

OPEN curEmail;
getEmail: LOOP
FETCH curEmail INTO endEmail;
IF fim = 1
THEN LEAVE getEmail;
END IF;
SET listaEmail = CONCAT(endEmail, ';', listaEmail);
END LOOP getEmail;
CLOSE curEmail;
END $$
DELIMITER ;

SET @listaEmail = '';
CALL criarLista(@listaEmail);
SELECT @listaEmail;

-- tabela temporaria

CREATE TEMPORARY TABLE temp_Cliente
SELECT DISTINCT c.id, c.nome, c.sobrenome, f.valor_total
FROM clientes c
INNER JOIN faturas f
ON c.id = f.id_cliente;

SELECT *
FROM temp_Cliente tc;

SELECT tc.nome, tc.sobrenome, sum(valor_total) totalFatura
FROM temp_CLiente tc
GROUP BY tc.nome;

-- ex aula assincrona

DELIMITER $$
CREATE PROCEDURE inserir_registro()
BEGIN
DECLARE id_reg int;
DECLARE id_fatura_reg int;
DECLARE id_cancao_reg int;
DECLARE preco_unit_reg DOUBLE;
DECLARE quantidade_reg int;
DECLARE fim int default 0;

DECLARE curInsert
CURSOR FOR SELECT id, id_fatura, id_cancao, preco_unitario, quantidade
FROM temp_itens_fatura;
DECLARE CONTINUE HANDLER FOR sqlexception SET fim = 1;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_itens_faturas
SELECT id, id_fatura, id_cancao, preco_unitario, quantidade
FROM itens_da_faturas;

OPEN curInsert;
addReg: LOOP
FETCH curInsert INTO id_reg, id_fatura_reg, id_cancao_reg, preco_unit_reg, quantidade_reg;
IF fim = 1
THEN LEAVE addReg;
ELSE
SET id_reg  = (SELECT max(f.id) + 1 FROM temp_itens_faturas f);
CALL inserir_registro(id_reg, id_fatura_reg, id_cancao_reg, preco_unit_reg, quantidade_reg);
END IF;
END LOOP addReg;
CLOSE curInsert;

END $$
DELIMITER ;

CALL inserir_registro();

SELECT * FROM temp_itens_faturas;

-- mesa
-- 01
DELIMITER $$
CREATE PROCEDURE sp_cliente_insert(prg varchar(10), psobrenome varchar(45), pnome varchar(50), pdata_nasc DATE)
BEGIN
INSERT INTO clientes(rg, sobrenome, nome, data_nasc)
VALUES(prg, psobrenome, pnome, pdata_nasc);
END $$
DELIMITER ;

CALL sp_cliente_insert('1234', 'Ferreira', 'Janete', '1967-09-22');

-- 02
DELIMITER $$
CREATE FUNCTION fn_ValidaIdade(datanasc datetime, datainicio datetime, qtdParcelas int)
RETURNS int
DETERMINISTIC
BEGIN
DECLARE valida int default 1;
DECLARE datafinal datetime;
DECLARE datafinalIdade datetime;

SET datafinal = date_add(datainicio, Interval qtdParcelas month);
SET datafinalIdade = date_add(datanasc, Interval 80 year);
IF datafinal > datafinalIdade
THEN SET valida = 0;
END IF;
RETURN valida;
END $$
DELIMITER ;

SELECT fn_validaIdade('1967-09-22', '2022-06-10', 20);

-- 03
DELIMITER $$
CREATE FUNCTION fn_diaUtil(data1 date)
RETURNS date
DETERMINISTIC
BEGIN
DECLARE diaUtil date;
IF weekday(data1) < 5
THEN SET diaUtil = data1;
ELSEIF weekday(data1) = 5
THEN SET diaUtil = date_add(data1, INTERVAL 2 day);
ELSE
SET diaUtil = date_add(data1, INTERVAL 1 day);
END IF;
RETURN diaUtil;
END $$
DELIMITER ;

SELECT fn_diaUtil('2022-06-05');

-- 04
DELIMITER $$
CREATE PROCEDURE SP_Gera_Parcela(IN pImporte decimal(10,2), pdataInicio date, pParcelas int)
BEGIN
DECLARE valorParcela decimal(10,2) default 1;
DECLARE vParcela int;
DECLARE dataParcela date;

SET vParcela = 1;
SET valorParcela = (pImporte / pParcelas);

DROP TABLE IF EXISTS tmpparcelas;
CREATE TEMPORARY TABLE tmpparcelas(nrParcela int, data1 date, importe decimal(10,2));
SET dataParcela = pDataInicio;
WHILE vParcela <= pParcelas DO
INSERT INTO tmpparcelas(nrParcela, data1, importe)
VALUES(vParcela, fn_diaUtil(dataParcela), valorParcela);
SET dataParcela = date_add(dataParcela, INTERVAL 30 day);
SET vParcela = vParcela + 1;
END WHILE;
SELECT nrParcela AS 'NR da Parcela',
DATE_FORMAT(data1, '%d/%m/%Y') AS 'data da Parcela',
importe AS 'Valor Parcela'
FROM tmpparcelas;
END $$
DELIMITER ;

CALL SP_Gera_Parcela(100000, '2022-01-01', 5);











