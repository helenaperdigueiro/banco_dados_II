DELIMITER $$
START TRANSACTION;
INSERT INTO generos
VALUES(30, 'Pancadao');
COMMIT;
 $$
DELIMITER ;

SELECT * FROM generos;

DELIMITER $$
START TRANSACTION;
SET foreign_key_checks = 0;
DELETE FROM generos
WHERE id = 30;
SET foreign_key_checks = 1;
SELECT * FROM generos;
ROLLBACK;
 $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insere_dados()
BEGIN
DECLARE erro_sql INT DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR sqlexception SET erro_sql = TRUE;
START TRANSACTION;
INSERT INTO generos
VALUES(31, 'salsa');
INSERT INTO generos
VALUES(32, 'forro');
INSERT INTO generos
VALUES(33, 'funk');
IF erro_sql = FALSE
THEN COMMIT;
SELECT 'Transacao efetivada com sucesso';
ELSE ROLLBACK;
SELECT 'Transacao cancelada';
END IF;
END $$
DELIMITER ;

CALL insere_dados();




