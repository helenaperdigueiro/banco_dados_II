-- Renata da Silva Leal
-- Carolina Hakamada
-- Romullo de Almeida
-- Marcelo Miyoshi
-- Helena Perdigueiro

delimiter $$
create procedure sp_distribuir_vacinas(data_inicio date, data_fim date)
begin
set qtd_lotes = (select sum(qtd)
				 from centrovacinacao_has_lote
				where Lote_idLote = 1);
                
set qtd_doses_por_lote = (select qtd
						  from lote
						  where idLote = 1);

set qtd_total_doses = qtd_lotes * qtd_doses_por_lote;

set qtd_postos = 3;

declare exit handler for sqlexception set erro = TRUE;

if qtd_total_doses > qtd_postos
then select 'O processo foi executado com sucesso';
else
declare exit handler for sqlexception
begin
select 'O processo teve erros'
end;

end $$
delimiter ;

