-- mesa

DELIMITER $$
CREATE FUNCTION verificaIdade(dataNascimento date)
RETURNS int DETERMINISTIC
BEGIN
DECLARE valida int default 0;
IF (timestampdiff(year, dataNascimento, curdate()) BETWEEN 18 AND 80)
THEN SET valida = 1;
ELSE
SET valida = 0;
END IF;
RETURN valida;
END $$
DELIMITER ;

SELECT verificaIdade('2004-05-31');

DELIMITER $$
CREATE FUNCTION verificaEmprestimo(idCliente int, valorEmprestimo decimal(10,2))
RETURNS int DETERMINISTIC
BEGIN
DECLARE valida int default 0;
DECLARE valorMaximoEmprestimo decimal(10,2);
SET valorMaximoEmprestimo = (SELECT maxLimite 
							FROM scoring 
                            INNER JOIN clientes 
                            ON Scoring_idScoring = idScoring
                            WHERE idclientes = idCliente);
IF valorEmprestimo <= valorMaximoEmprestimo
THEN SET valida = 1;
ELSE
SET valida = 0;
END IF;
RETURN valida;
END $$
DELIMITER ;

SELECT verificaEmprestimo(1, 10000.01);


DELIMITER $$
CREATE PROCEDURE sp_emprestimo(codCliente int, valor decimal(10,2), dataInicio date, qtdParcelas int, tipo int)
BEGIN
DECLARE entre18e80 int;
DECLARE parcelaFinalAntesDe80 int;
DECLARE valorEmprestimoPermitido int;
SET entre18e80 = (SELECT verificaIdade((SELECT data_nasc 
									  FROM clientes 
                                      WHERE idclientes = codCliente)));
SET parcelaFinalAntesDe80 = (SELECT fn_ValidaIdade((SELECT data_nasc 
												  FROM clientes 
                                                  WHERE idclientes = codCliente), dataInicio, qtdParcelas));
SET valorEmprestimoPermitido = (SELECT verificaEmprestimo(codCliente, valor));

IF (entre18e80 = 1) AND (parcelaFinalAntesDe80 = 1) AND (valorEmprestimoPermitido = 1)
THEN CALL SP_Gera_Parcela(valor, dataInicio, qtdParcelas);
ELSE
SELECT 'nao foi possivel realizar emprestimo' AS mensagem;
END IF;
END $$
DELIMITER ;

CALL sp_emprestimo(1, 900.00, '2022-06-02', 20, 1);



-- Carolina Hakamada
-- 










