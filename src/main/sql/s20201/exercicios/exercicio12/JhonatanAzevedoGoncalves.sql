/*Criar uma fnção em PL/pgSQL, utilizando cursores, para atualizar a tabela
produto{código, categoria, valor} conforme regra abaixo.
1. Produtos da categoria A deverão ser reajustados em 5%
2. Produtos da categoria B deverão ser reajustados em 10%
3. Produtos da categoria C deverão ser reajustados em 15%*/

drop table if exists produto;
create table produto(codigo int, categoria varchar(100), valor real); 

insert into produto values
(1, 'A', 10),
(2, 'D', 20),
(3, 'B', 30),
(4, 'B', 40),
(5, 'C', 50);


create or replace function att_tabela() returns void as $$

declare 
 curs cursor for select * from produto;
 i record;
 r float;
begin
	for i in curs loop
		if(i.categoria = 'A')then r := 1.05;
		elsif(i.categoria = 'B')then r := 1.1;
		elsif(i.categoria = 'C')then r := 1.15;
		else r:= 1;
		end if;
		UPDATE produto SET valor = valor*r WHERE CURRENT OF curs;
	end loop;

	
end
$$language plpgsql;

select att_tabela();

select * from produto;
