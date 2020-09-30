

-- DROP TABLES AND FUNCTIONS
DO $$ BEGIN
    PERFORM drop_functions();
END $$;



DROP TABLE IF EXISTS empregado cascade;
DROP TABLE IF EXISTS dependente cascade;
DROP SEQUENCE IF EXISTS empregado_sequence;
DROP SEQUENCE IF EXISTS dependente_sequence;

-- Sequences
CREATE SEQUENCE empregado_sequence START 1;
CREATE SEQUENCE dependente_sequence START 1;

-- Tables
CREATE TABLE empregado (
    empregado_id INTEGER NOT NULL DEFAULT nextval('empregado_sequence'),
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY
    (empregado_id)
);

CREATE TABLE dependente (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL DEFAULT nextval('dependente_sequence'),
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY
    (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY
    (empregado_id) REFERENCES empregado
    (empregado_id)
);

-- Carga de empregados e dependentes
INSERT INTO empregado(nome, salario, adicional_dep) VALUES ('Philippe', 4500, 100);

INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente Philippe');
INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente2 Philippe');
INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente3 Philippe');

INSERT INTO empregado(nome, salario, adicional_dep) VALUES ('Joao', 3000, 200);
INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente Joao');
INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente2 Joao');
INSERT INTO dependente(empregado_id, nome) VALUES ((SELECT CURRVAL('empregado_sequence')), 'Dependente3 Joao');


-- Functions

CREATE OR REPLACE FUNCTION adicional_salarial() RETURNS VOID AS $$
    DECLARE
		empr RECORD;
        numDependentes integer;
		adicional_dependente real;
    BEGIN
        FOR empr IN SELECT empregado.empregado_id FROM empregado LOOP
            numDependentes := (SELECT COUNT(empregado_id) FROM dependente WHERE empr.empregado_id = dependente.empregado_id);
            EXECUTE 'UPDATE empregado SET adicional_dep = adicional_dep * (1 + ($1 * 0.05)) WHERE empregado_id = $2' USING numDependentes, empr.empregado_id;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;



SELECT adicional_salarial();

SELECT * FROM EMPREGADO; -- 1 / Philippe / 4500 / 115
