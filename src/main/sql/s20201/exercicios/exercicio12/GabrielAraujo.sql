drop table if exists produto; 
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
	
create or replace function reajustar_preco() returns void as $$
declare
    consulta cursor for select * from produto;
    reajuste real;

begin
    for r in consulta loop
        if(r.categoria = 'A')then 
			reajuste := 1.05;
        elsif(r.categoria = 'B')then 
			reajuste := 1.1;
        elsif(r.categoria = 'C')then 
			reajuste := 1.15;
        else reajuste:= 1;
        end if;
        UPDATE produto SET valor = valor * reajuste WHERE CURRENT OF consulta;
   end loop;
END
$$language plpgsql;

SELECT reajustar_preco();
SELECT * FROM PRODUTO;