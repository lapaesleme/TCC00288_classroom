drop function if exists atualizaCategoria cascade;
drop table if exists produto cascade;

CREATE TABLE produto (
codigo integer NOT NULL,
categoria character varying NOT NULL,
valor real NOT NULL,
CONSTRAINT produto_pk PRIMARY KEY
(codigo)
);

INSERT INTO produto values
    (1, 'A', 2.5),
    (2, 'A', 5),
    (3, 'B', 10),
    (4, 'B', 20),
    (5, 'B', 30),
    (6, 'C', 40);


create or replace function atualizaCategoria() RETURNS void as $$
declare
    consulta cursor for select * from produto;
    reajuste real;
    
begin
    for record in consulta loop
        if(record.categoria = 'A')then reajuste := 1.05;
        elsif(record.categoria = 'B')then reajuste := 1.1;
        elsif(record.categoria = 'C')then reajuste := 1.15;
        else reajuste:= 1;
        end if;
        UPDATE produto SET valor = valor * reajuste WHERE CURRENT OF consulta;
   end loop;
END
$$ LANGUAGE plpgsql;


select * from produto;
select atualizaCategoria();
select * from produto;

