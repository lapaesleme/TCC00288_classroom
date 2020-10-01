DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS empregado CASCADE;
DROP TABLE IF EXISTS dependente CASCADE;

CREATE TABLE empregado (
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY
    (empregado_id)
);

CREATE TABLE dependente (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY
    (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY
    (empregado_id) REFERENCES empregado
    (empregado_id)
);

INSERT INTO empregado VALUES(0, 'Jose', 1000, 100);
INSERT INTO dependente VALUES(0, 1, 'Maria');

INSERT INTO empregado VALUES(1, 'Gabriel', 2000, 100);

INSERT INTO empregado VALUES(2, 'Joao', 1000, 100);
INSERT INTO dependente VALUES(2, 2, 'Huguinho');
INSERT INTO dependente VALUES(2, 3, 'Zezinho');
INSERT INTO dependente VALUES(2, 4, 'Luizinho');

CREATE OR REPLACE FUNCTION atualizaDados() RETURNS VOID AS $$
DECLARE
    funcionario RECORD;
BEGIN
    FOR funcionario IN SELECT empregado.empregado_id, COUNT(empregado.empregado_id) as dependentes FROM empregado, dependente WHERE empregado.empregado_id = dependente.empregado_id GROUP BY empregado.empregado_id LOOP
        EXECUTE 'UPDATE empregado SET adicional_dep = adicional_dep * (1 + ($1 * 0.05)) WHERE empregado_id = $2' USING funcionario.dependentes, funcionario.empregado_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;


SELECT * FROM empregado;
SELECT * FROM dependente;

DO $$ BEGIN
    PERFORM atualizaDados();
END $$;

SELECT * FROM empregado;