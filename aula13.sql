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