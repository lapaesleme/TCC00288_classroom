drop table if exists produto;
Create table produto(
	codigo integer,
	nome varchar(100),
	preco real
);

INSERT INTO produto values
    (1, 'Iogurte', 2.5),
    (2, 'Chocolate', 8),
    (3, 'Bala', 0.2);

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
