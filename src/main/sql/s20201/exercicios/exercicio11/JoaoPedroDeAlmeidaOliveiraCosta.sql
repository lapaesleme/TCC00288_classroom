drop function if exists reajuste cascade;
drop table if exists produto cascade;

CREATE TABLE produto (
codigo integer NOT NULL,
nome character varying NOT NULL,
preco real NOT NULL,
CONSTRAINT produto_pk PRIMARY KEY
(codigo)
);


INSERT INTO produto values
    (1, 'Chocolate', 2.5),
    (2, 'Caderno', 10),
    (3, 'Bala', 0.1);




create or replace function reajuste() RETURNS void as $$
declare
    Record record;
begin
   for Record in select * from produto loop
            update produto set preco = (produto.preco * 1.1) where codigo = Record.codigo;
   end loop;
END
$$ LANGUAGE plpgsql;




select * from produto;

select reajuste();

select * from produto;