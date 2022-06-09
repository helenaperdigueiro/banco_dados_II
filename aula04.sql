-- Banco adventureworks

create table Employee_Age(FirstName varchar(50), LastName varchar(50), Age TinyInt);

////////////////////////////////////

delimiter $$
create function calcula_idade(dataNasc date) returns tinyint
deterministic 
begin
declare resultado tinyint;
set resultado = (select timestampdiff(year, dataNasc, curdate()));
return resultado;
end $$
delimiter ;

/////////////////////////////////

delimiter $$
create procedure inserirIdade (in pegaIdade tinyint)
begin

insert into Employee_Age(FirstName, LastName, Age)
select c.FirstName as Nome, c.LastName as Sobrenome, calcula_idade(BirthDate) as idade
from employee e
inner join contact c
on e.ContactID = c.ContactID
where calcula_idade(BirthDate) = pegaIdade;
end $$
delimiter ;

call inserirIdade(63);