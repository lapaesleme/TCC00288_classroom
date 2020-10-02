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

INSERT INTO empregado VALUES(0, 'Maria', 1000, 100);
INSERT INTO dependente VALUES(0, 0, 'Luiza');

INSERT INTO empregado VALUES(1, 'Vitoria', 2000, 100);
INSERT INTO dependente VALUES(1, 1, 'Alice');
INSERT INTO dependente VALUES(1, 2, 'Sofia');

INSERT INTO empregado VALUES(2, 'Barbara', 1500, 100);

INSERT INTO empregado VALUES(3, 'Julia', 2000, 100);
INSERT INTO dependente VALUES(3, 3, 'Carla');
INSERT INTO dependente VALUES(3, 4, 'Debora');
INSERT INTO dependente VALUES(3, 5, 'Eduarda');

CREATE OR REPLACE FUNCTION atualizarAdicionalDep() RETURNS VOID AS $$
DECLARE
    emp RECORD;
BEGIN
    FOR emp IN SELECT empregado.empregado_id, COUNT(empregado.empregado_id) as dependentes FROM empregado, dependente WHERE empregado.empregado_id = dependente.empregado_id GROUP BY empregado.empregado_id LOOP
        EXECUTE 'UPDATE empregado SET adicional_dep = adicional_dep * (1 + ($1 * 0.05)) WHERE empregado_id = $2' USING emp.dependentes, emp.empregado_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;


SELECT * FROM empregado;
SELECT * FROM dependente;

DO $$ BEGIN
    PERFORM atualizarAdicionalDep();
END $$;

SELECT * FROM empregado;
