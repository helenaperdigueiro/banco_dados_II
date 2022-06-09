-- aula

SELECT a.AddressLine1 AS Logradouro, sp.Name AS EstadoProvincia
FROM address a
INNER JOIN stateprovince sp
ON a.StateProvinceID = sp.StateProvinceID
WHERE a.StateProvinceID = 79
ORDER BY AddressLine1 DESC
LIMIT 3
OFFSET 550;

SELECT sp.Name as Estado, COUNT(a.AddressID) AS qtdEndereco
FROM stateprovince sp
INNER JOIN address a
ON sp.StateProvinceID = a.StateProvinceID
GROUP BY Estado
HAVING qtdEndereco > 1000;

-- mesa
-- where
-- 01
SELECT c.FirstName AS PrimeiroNome, c.MiddleName AS SegundoNome, c.LastName AS Sobrenome
FROM contact c
WHERE c.LastName
LIKE '_a%';

-- 02
SELECT CONCAT(c.Title, ' ', c.FirstName, ' ', c.LastName) AS NomeCompleto
FROM contact c
WHERE c.Title = 'Mr.' OR 
      c.Title = 'Ms.';

-- 03
SELECT p.Name AS Nome, p.ProductNumber AS NumeroProduto
FROM product p
WHERE p.ProductNumber LIKE 'AR%' OR
	  p.ProductNumber LIKE 'BE%' OR
      p.ProductNumber LIKE 'DC%';

-- 04
SELECT c.ContactID AS ID, c.FirstName AS PrimeiroNome, c.LastName AS Sobrenome
FROM contact c
WHERE c.FirstName
LIKE 'C%' AND
	c.FirstName NOT LIKE '_o%' AND
	c.FirstName NOT LIKE '_e%';

-- 05
SELECT p.Name AS PrimeiroNome, p.ListPrice AS Preco
FROM product p
WHERE p.ListPrice
BETWEEN 400 AND 500;

-- 06
SELECT e.EmployeeID AS IDEmpregado, e.ContactID AS IDContato, e.Title AS Titulo, e.BirthDate AS AnoNascimento
FROM employee e
WHERE YEAR(e.BirthDate) % 2 = 0
BETWEEN 1960 and 1980;

-- operadores e joins
-- 01
SELECT e.EmployeeID AS IDEmpregado, e.Title AS Titulo, e.HireDate AS DataContratacao, e.VacationHours AS HorasFerias
FROM employee e
HAVING YEAR (e.HireDate) > 2000;

-- 02
SELECT p.Name AS Nome, p.ProductNumber AS NumeroProduto, p.ListPrice AS Preco, p.SellEndDate AS DataVenda, p.ListPrice*1.1 AS PrecoNovo
FROM product p
HAVING (p.SellEndDate) < NOW();

-- group by
-- 01
SELECT YEAR (e.BirthDate) AS AnoNascimento, COUNT(e.employeeID) AS qtdFuncionarios
FROM employee e
GROUP BY YEAR (e.BirthDate);

-- 02
SELECT YEAR (p.SellStartDate) AS DataInicioVenda, ROUND(AVG(p.ListPrice)) AS PrecoMedio
FROM product p
GROUP BY YEAR (p.SellStartDate);

-- 03
SELECT sod.ProductID AS IDProduto, SUM(sod.LineTotal) AS qtdVendidos
FROM salesorderdetail sod
GROUP BY sod.ProductID;

-- 04
SELECT sod.SalesOrderID AS IDFatura, ROUND(AVG(sod.LineTotal), 2) AS MediaPorFatura
FROM salesorderdetail sod
GROUP BY sod.SalesOrderID;

-- having
-- 01
SELECT p.ProductSubcategoryID AS Subcategoria, p.ListPrice AS Preco
FROM product p
INNER JOIN salesorderdetail sod
ON p.ProductID = sod.ProductID
WHERE sod.OrderQty >= 2
GROUP BY p.ProductSubcategoryID
HAVING p.ListPrice < 200;

-- 02
SELECT p.ProductSubcategoryID AS Subcategoria, COUNT(p.ProductID) AS qtdProdutos
FROM product p
WHERE p.ListPrice > 100
GROUP BY p.ProductSubcategoryID
HAVING AVG(p.ListPrice) < 300;

-- join
-- 01
SELECT p.Name AS Produto, sod.UnitPrice AS PrecoVenda
FROM salesorderdetail sod
INNER JOIN product p
ON sod.ProductID = p.ProductID
WHERE sod.UnitPrice < p.ListPrice;

-- 02
SELECT p.ProductID AS IDProduto, p.Name AS Produto, p.ListPrice AS Preco, p2.ProductID AS IDProduto, p2.Name AS Produto, p2.ListPrice AS Preco
FROM product p
INNER JOIN product p2
ON p.ListPrice = p2.ListPrice
ORDER BY p.ListPrice DESC;

-- 03
SELECT p.Name AS Produto, v.Name AS Fornecedor
FROM product p
INNER JOIN productvendor pv
ON p.ProductID = pv.ProductID
INNER JOIN vendor v
ON pv.VendorID = v.VendorID
ORDER BY v.Name DESC;

-- 04
SELECT c.FirstName AS PrimeiroNome, c.LastName AS Sobrenome, e.LoginID AS IDLogin 
FROM contact c
LEFT JOIN employee e
ON c.ContactID = e.ContactID;


-- Giovani Silva
-- Carolina Hakamada
-- Nathalia Vieira
-- Bruno Barbosa
-- Janete =)