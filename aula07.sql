SHOW VARIABLES LIKE '%port%';

-- variaveis de usuario
SET @genero = 'lambada';
SELECT @genero;

SELECT @tipoID := id, @tipoNome := nome FROM generos;
SELECT @tipoID, @tipoNome;

-- variaveis locais
DELIMITER $$
CREATE FUNCTION adicionar_IVA(preço_sem_taxas decimal(10,2))
RETURNS decimal(10,2)
DETERMINISTIC
BEGIN	
     DECLARE IVA INT DEFAULT 21;
     RETURN ((preço_sem_taxas * IVA) / 100) + preço_sem_taxas;
END $$
DELIMITER ;

SELECT adicionar_IVA(10.00);

-- variaveis globais
SHOW VARIABLES;
SHOW GLOBAL VARIABLES;
SHOW SESSION VARIABLES;
SHOW GLOBAL VARIABLES LIKE 'max_%';
SELECT @@global.sort_buffer_size;

-- mesa
DELIMITER $$
CREATE PROCEDURE calcular_soma_media(IN numeros VARCHAR(100), OUT soma decimal(10,2), OUT media decimal(10,2))
BEGIN
DECLARE quantidade int DEFAULT 0;
SET soma = 0;
loop_simple: LOOP
SET quantidade = quantidade + 1;
CASE WHEN(CAST(left(numeros, locate(';', numeros) -1) AS decimal(10,2)) > 0)
THEN SET soma = soma + (CAST(left(numeros, locate(';', numeros) -1) AS decimal(10,2)));
ELSE SET quantidade = quantidade - 1;
END CASE;
SET numeros = RIGHT(numeros, CHAR_LENGTH(numeros) - LOCATE(';', numeros));
IF (LOCATE(';', numeros) = 0)
THEN LEAVE loop_simple;
END IF;
END LOOP;
SET media = soma / quantidade;
END $$
DELIMITER ;

CALL calcular_soma_media('10;66;138;37;-72;0.5;', @soma, @media);
SELECT @soma, @media;

-- janete

-- CREATE PROCEDURE numeros (IN numeros VARCHAR(100), OUT soma DOUBLE, OUT media DOUBLE)
-- BEGIN
-- 	DECLARE quantidade INT DEFAULT 0;
-- 	SET soma = 0;
-- 	numeros_loop: LOOP
-- 		SET quantidade = quantidade + 1;
--         CASE WHEN (CAST(LEFT(numeros, LOCATE(';', numeros) - 1) AS DOUBLE) > 0) THEN
-- 			SET soma = soma + CAST(LEFT(numeros, LOCATE(';', numeros) - 1) AS DOUBLE);
-- 		ELSE
-- 			SET quantidade = quantidade - 1;
-- 		END CASE;
-- 		SET numeros = RIGHT(numeros, CHAR_LENGTH(numeros) - LOCATE(';', numeros));
--         IF (LOCATE(';', numeros) = 0) THEN
-- 			LEAVE numeros_loop;
-- 		END IF;
--     END LOOP;
--     SET media = soma / quantidade;
-- END $$

-- CALL numeros ('10;66;138;37;-72;0.5;', @soma, @media);
-- SELECT @soma, @media;






-- helena, carol, renata, romullo, giovani, marcos
