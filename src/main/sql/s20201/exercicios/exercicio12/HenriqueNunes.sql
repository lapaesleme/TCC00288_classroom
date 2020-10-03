DROP TABLE IF EXISTS produto;
CREATE TABLE produto (
codigo          integer NOT NULL,
categoria       character varying NOT NULL,
nome            character varying NOT NULL,
preco           real NOT NULL
);

insert into produto(codigo,categoria,nome,preco) values
(1, 'A','batata',2)
,(2, 'A','jujuba',3)
,(3, 'B','azeitona',10)
,(4, 'C','cerveja',2.59)
;

DROP FUNCTION IF EXISTS reajusta();
CREATE or REPLACE FUNCTION reajusta() 
RETURNS integer 
AS $$

DECLARE
    row_aux RECORD;
BEGIN
    FOR row_aux IN SELECT * FROM produto LOOP
        UPDATE produto p set preco=preco*1.05 WHERE p.codigo=row_aux.codigo AND categoria='A';
        UPDATE produto p set preco=preco*1.1 WHERE p.codigo=row_aux.codigo AND categoria='B';
        UPDATE produto p set preco=preco*1.15 WHERE p.codigo=row_aux.codigo AND categoria='C';
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql;

select * from produto;
select reajusta() as a;
select * from produto;

