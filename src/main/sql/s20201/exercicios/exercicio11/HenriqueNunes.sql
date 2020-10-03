DROP TABLE IF EXISTS produto;
CREATE TABLE produto (
codigo          integer NOT NULL,
nome            character varying NOT NULL,
preco           real NOT NULL
);

insert into produto(codigo,nome,preco) values
(1,'batata',2)
,(2,'jujuba',3)
,(3,'azeitona',10)
,(4, 'cerveja',2.59)
;

DROP FUNCTION IF EXISTS reajusta();
CREATE or REPLACE FUNCTION reajusta() 
RETURNS integer 
AS $$

DECLARE
    row_aux RECORD;
BEGIN
    FOR row_aux IN SELECT * FROM produto LOOP
        UPDATE produto p set preco=preco*1.1 WHERE p.codigo=row_aux.codigo;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql;

select * from produto;
select reajusta() as a;
select * from produto;
