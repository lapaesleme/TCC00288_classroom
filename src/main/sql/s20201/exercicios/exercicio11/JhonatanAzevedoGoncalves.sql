/*Escreva uma função PL/pgSQL Para reajustar os preços dos produtos na relação
produto{codigo,nome,preco} em 10%. Use for ... loop.*/

drop table if exists produto;
create table produto(codigo int, nome varchar(100), preco real); 

insert into produto values
(1, 'a', 10),
(2, 'a', 20),
(3, 'a', 30),
(4, 'a', 40),
(5, 'a', 50);


create or replace function reajustar_preco() returns void as $$
declare
	i produto%rowtype;
begin
	for i in select * from produto loop
		update produto set preco = i.preco + (i.preco*0.1) where produto.preco = i.preco;
	end loop;
end
$$language plpgsql;

select reajustar_preco();

select * from produto;
