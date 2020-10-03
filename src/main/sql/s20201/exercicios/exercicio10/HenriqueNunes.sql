DROP TABLE IF EXISTS empregado;
CREATE TABLE empregado (
empregado_id    integer NOT NULL,
nome            character varying NOT NULL,
salario         real NOT NULL,
adicional_dep   real NOT NULL,
CONSTRAINT empregado_pk PRIMARY KEY (empregado_id)
);

DROP TABLE IF EXISTS dependente;
CREATE TABLE dependente (
empregado_id    integer NOT NULL,
seq             smallint NOT NULL,
nome            character varying NOT NULL,
CONSTRAINT dependente_pk PRIMARY KEY(empregado_id, seq),
CONSTRAINT empregado_fk FOREIGN KEY(empregado_id) REFERENCES empregado(empregado_id)
);

INSERT INTO empregado(empregado_id,nome,salario,adicional_dep) VALUES
(1,'Astolfo',1000,1),
(2,'Rosiane',1200,1.1),
(3,'Madalena', 2000, 1.13)
;

INSERT INTO dependente(empregado_id,seq,nome) VALUES
(1,1,'Fabi'),
(1,2,'Josefina'),
(2,3,'Ronaldo')
;

DROP FUNCTION IF EXISTS atualiza;
CREATE or REPLACE FUNCTION atualiza() 
RETURNS integer 
AS $$
DECLARE
    row_aux RECORD;
    how_many int;
BEGIN
    FOR row_aux IN SELECT * FROM empregado LOOP
        SELECT COUNT(*) FROM dependente d WHERE d.empregado_id = row_aux.empregado_id INTO how_many;
        UPDATE empregado e set adicional_dep=adicional_dep*(1+how_many*0.05) WHERE e.empregado_id=row_aux.empregado_id;
    END LOOP;

  RETURN 0;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM empregado;

select atualiza() as a;

SELECT * FROM empregado;