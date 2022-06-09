-- 01

CREATE TABLE auditoriaCreditCard(usuario varchar(30), 
								 acao varchar(30), 
                                 dataModificacao datetime, 
                                 CreditCardID int, 
                                 CardType varchar(50), 
                                 CardNumber varchar(25), 
                                 ExpMonth tinyint, 
                                 ExpYear smallint);

DELIMITER $$
CREATE TRIGGER auditarCreditCardInsert
AFTER INSERT ON creditcard FOR EACH ROW
BEGIN
INSERT INTO auditoriacreditcard(usuario, acao, dataModificacao, CreditCardID, CardType, CardNumber, ExpMonth, ExpYear)
VALUES((SELECT current_user()), 'Insert', now(), NEW.CreditCardID, NEW.CardType, NEW.CardNumber, NEW.ExpMonth, NEW.ExpYear);
END $$
DELIMITER ;

INSERT INTO creditcard(CreditCardID, CardType, CardNumber, ExpMonth, ExpYear)
VALUES(20000, 'BananaBank', '123456', 5, 4);

DELIMITER $$
CREATE TRIGGER auditarCreditCardUpdate
AFTER UPDATE ON creditcard FOR EACH ROW
BEGIN
INSERT INTO auditoriacreditcard(usuario, acao, dataModificacao, CreditCardID, CardType, CardNumber, ExpMonth, ExpYear)
VALUES((SELECT current_user()), 'Update', now(), NEW.CreditCardID, NEW.CardType, NEW.CardNumber, NEW.ExpMonth, NEW.ExpYear);
END $$
DELIMITER ;

UPDATE creditcard
SET CardType = 'BananaCard'
WHERE CreditCardID = 20000;

DELIMITER $$
CREATE TRIGGER auditarCreditCardDelete
AFTER DELETE ON creditcard FOR EACH ROW
BEGIN
INSERT INTO auditoriacreditcard(usuario, acao, dataModificacao, CreditCardID, CardType, CardNumber, ExpMonth, ExpYear)
VALUES((SELECT current_user()), 'Delete', now(), OLD.CreditCardID, OLD.CardType, OLD.CardNumber, OLD.ExpMonth, OLD.ExpYear);
END $$
DELIMITER ;

DELETE FROM creditcard
WHERE CreditCardID = 20000;

DROP TRIGGER auditarCreditCardDelete;

-- 02

DELIMITER $$
CREATE PROCEDURE inserirDadoCreditCard(CreditCardID int, 
									   CardType varchar(50), 
									   CardNumber varchar(25), 
                                       ExpMonth tinyint, 
                                       ExpYear smallint)
BEGIN
DECLARE erro INT DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR sqlexception SET erro = TRUE;
START TRANSACTION;
INSERT INTO creditcard(CreditCardID, CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate)
VALUES(CreditCardID, CardType, CardNumber, ExpMonth, ExpYear, now());
IF erro = FALSE
THEN COMMIT;
SELECT 'Dados inseridos com sucesso!';
ELSE ROLLBACK;
SELECT 'Algo deu errado. Dados nao foram inseridos.';
END IF;
END $$
DELIMITER ;

CALL inserirDadoCreditCard(20000, 'BananaBank', '123456', 5, 4);

-- 03



