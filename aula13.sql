show index from cancoes;

create index idx_nome on cancoes(nome);

create fulltext index idx_title on employee(title);

select title, count(ContactID) as qtd
from employee
where match(title) against('Production Technician')
group by title;

select title
from employee
where match(title) against ('+Marketing -Manager' in boolean mode);

show index from productmodel;
create fulltext index idx_descmodel
on productmodel(name, catalogDescription);

select name as modelo, count(productmodelID) as qtd
from productmodel
where match(name, catalogDescription)
against('A light yet stiff aluminum bar for long distance riding')
group by name;

select * from productmodel
where CatalogDescription like '%light yet stiff aluminum bar for long distance riding%';

-- mesa
-- 01
create fulltext index idx_product_description
on productdescription(description);

show index from productdescription;

-- 02
select pm.name as nome_do_modelo, count(pd.productdescriptionID) as qtd
from productdescription pd
inner join productmodelproductdescriptionculture pmpdc
on pd.ProductDescriptionID = pmpdc.ProductDescriptionID
inner join productmodel pm
on pmpdc.ProductModelID = pm.ProductModelID
where match(description)
against('Suitable for any type of riding, on or off-road')
group by pm.name;

-- 24 registros retornaram
-- 0.047 sec
-- 'Road-550-W' e 'Road-550'

-- 03
select pm.name, match(description) against('Suitable for any type of riding, on or off-road') as porcentagem_relevancia
from productdescription pd
inner join productmodelproductdescriptionculture pmpdc
on pd.ProductDescriptionID = pmpdc.ProductDescriptionID
inner join productmodel pm
on pmpdc.ProductModelID = pm.ProductModelID
where match(description)
against('Suitable for any type of riding, on or off-road')
group by pm.name;

-- 'Mountain-500'
-- 'LL Road Rear Wheel'
-- 0.016 sec

-- 04
show index from productdescription;

-- índice clusterizado: 'ProductDescriptionID'
-- índice não clusterizado: 'Description'
-- 'BTREE'
-- 'FULLTEXT'

-- 05
-- tamanho: 77.3 MB
-- maior tabela: 12.5 MB

-- 06
-- 144.0 KB

-- 07
-- 762
-- Tem 762 descrições diferentes na tabela productdescription. Tem mais descrições que isso, mas apenas 762 diferentes.

-- 08
alter table productdescription
drop index idx_product_description;

show index from productdescription;




