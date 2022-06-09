-- trigger

ALTER TABLE categorias ADD userInsert varchar(50);
ALTER TABLE categorias ADD dataInsert datetime;

DELIMITER $$
CREATE TRIGGER trg_Insert_Categoria
BEFORE INSERT ON categorias FOR EACH ROW
BEGIN
SET NEW.userInsert = (SELECT current_user());
SET NEW.dataInsert = now();
END $$
DELIMITER ;

INSERT INTO categorias(CategoriaNome, Descricao)
VALUES('Drugs', 'Produtos para a saude');

-- subconsulta escalar
SELECT c.contato, f.FaturaId, f.DataFatura
FROM clientes c
INNER JOIN faturas f
ON c.ClienteID = f.ClienteID
WHERE f.DataFatura = (SELECT min(DataFatura) FROM faturas WHERE YEAR(DataFatura) = 1998);

-- subconsulta
SELECT p.ProdutoId, p.ProdutoNome
FROM produtos p
WHERE
EXISTS( SELECT d.ProdutoID FROM detalhefatura d WHERE d.ProdutoID = p.ProdutoID)
ORDER BY p.ProdutoID;

SELECT p.ProdutoId, p.ProdutoNome
FROM produtos p
WHERE
EXISTS( SELECT d.ProdutoID 
		FROM detalhefatura d 
        GROUP BY d.ProdutoID 
        HAVING d.ProdutoID = p.ProdutoID 
        AND COUNT(d.ProdutoID) > 50)
        
ORDER BY p.ProdutoID;

-- handler

DELIMITER $$
CREATE PROCEDURE add_handler(cnome varchar(50), cdescricao varchar(200))
BEGIN
DECLARE nulo int default 0;
BEGIN
DECLARE EXIT HANDLER FOR 1048 SET nulo = 1;
INSERT INTO categorias(CategoriaNome, Descricao)
VALUES(cnome, cdescricao);
SELECT 'Categoria cadastrada com sucesso';
END;
IF nulo = 1
THEN SELECT 'Informe todos os parametros';
END IF;
END $$
DELIMITER ;

CALL add_handler(null, 'Limpeza');

-- mesa
-- 01
ALTER TABLE parcelas ADD modificadoPor varchar(50);
ALTER TABLE parcelas ADD excluidoPor varchar(50);

CREATE TABLE historicoUpdateEDelete(idparcelas int, idemprestimo int, dataParcela date, importe decimal(10, 2), acao varchar(30), usuario varchar(30), dataModificacao datetime);

DELIMITER $$
CREATE TRIGGER parcelaModificada
AFTER UPDATE ON parcelas FOR EACH ROW
BEGIN
INSERT INTO historicoUpdateEDelete(idparcelas, idemprestimo, dataParcela, importe, acao, usuario, dataModificacao)
VALUES(NEW.idParcelas, NEW.idemprestimo, NEW.dataParcela, NEW.importe, 'Update', current_user(), now());
END $$
DELIMITER ;

DROP TRIGGER parcelaExcluida;

UPDATE parcelas
SET importe = 1000.00
WHERE idparcelas = 1;

DELIMITER $$
CREATE TRIGGER parcelaExcluida
AFTER DELETE ON parcelas FOR EACH ROW
BEGIN
INSERT INTO historicoUpdateEDelete(idparcelas, idemprestimo, dataParcela, importe, acao, usuario, dataModificacao)
VALUES(OLD.idParcelas, OLD.idemprestimo, OLD.dataParcela, OLD.importe, 'Delete', current_user(), now());
END $$
DELIMITER ;

DELETE FROM parcelas
WHERE idparcelas = 2;


-- 02 - nao finalizado
DELIMITER $$
CREATE PROCEDURE SP_Gera_Parcela(IN pImporte decimal(10,2), pDataInicio date, pParcelas int)
BEGIN
DECLARE valorParcela decimal(10,2) default 1;
DECLARE nParcela int;
DECLARE dataParcela date;
DECLARE e_code varchar(1000);
DECLARE e_msg varchar(1000);

DECLARE EXIT HANDLER FOR sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
e_code = returned_sqlstate, e_msg = message_text;
SELECT e_code, e_msg;
END;

SET nParcela=1;
SET valorParcela = (pImporte/pParcelas);

DROP TABLE IF EXISTS tmpParcelas;
CREATE TEMPORARY TABLE tmpParcelas(nrParcela int, dataParcela date, importe decimal(10,2));

SET dataParcela = pDataInicio;
WHILE nParcela <= pParcelas DO
INSERT INTO tmpParcelas(nrParcela, dataParcela, importe)
VALUES(nParcela, fn_diaUtil(dataParcela), valorParcela);
SET dataParcela = Date_add(dataParcela, Interval 30 day);
SET nParcela = nParcela + 1;
END WHILE;
SELECT nrParcela as 'Nr da Parcela', DATE_FORMAT(dataParcela, '%d/%m/%Y') as 'Data da Parcela', importe as 'Valor da Parcela'
FROM tmpParcelas;
END $$
DELIMITER ;

CALL SP_Gera_Parcela(10000.00, '2022-06-07', 10);

-- 03

SELECT *
FROM parcelas
WHERE parcelas.dataParcela = (curdate()+1)
AND
 (SELECT SUM(parcelas.importe) 
  FROM parcelas
  WHERE parcelas.dataParcela < curdate()
  GROUP BY parcelas.idemprestimo) > (0.3*(SELECT e.importe 
										  FROM emprestimo e
										  INNER JOIN parcelas p
										  ON e.idEmprestimo = p.idemprestimo
                                          GROUP BY e.idEmprestimo));





