set global general_log = on;
set global log_output = 'table';
select * from mysql.general_log;

SELECT a.nome, b.titulo
FROM artistas a
INNER JOIN albuns b
ON a.id = b.id_artista;

select p.productID, p.name, sod.orderQTY, sod.linetotal
from product p 
left join salesorderdetail sod
on p.ProductID = sod.ProductID
where year(sod.modifiedDate) = 2004;

-- mesa

SELECT P.ProductID Codigo, P.Name Descricao, M.Name Produto
FROM Product P 
INNER JOIN ProductModel M
ON P.ProductModelID = M.ProductModelID;

-- 01

-- 505 linhas
-- 504 linhas
-- 1 linha
-- 511.8

-- 02

-- O resultado visual é diferente. Mas os resultados de custo e quantidade de linhas são iguais.
-- Não foi utilizado nenhum index ou condição.

-- 03

-- Adicionar um index e/ou condição.

-- 04

SELECT P.ProductID Codigo, P.Name Descricao, M.Name Produto
FROM Product P 
INNER JOIN ProductModel M
ON P.ProductModelID = M.ProductModelID
WHERE p.productID BETWEEN 0 AND 743;

-- O relatório mostra que agora a consulta foi index range scan.
-- Custo média (parcial index scan).

-- 05

SELECT P.ProductID Codigo, P.Name Descricao, M.Name Produto
FROM Product P 
INNER JOIN ProductModel M
ON P.ProductModelID = M.ProductModelID
WHERE p.productID = 743;

-- O relatório mostra que agora a consulta foi constante.
-- Custo muito baixo (very low cost).

-- sophia
-- bruno barbosa
-- marcelo nader