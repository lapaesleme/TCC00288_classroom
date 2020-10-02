DO $$ BEGIN
    PERFORM drop_functions(); -- Não funcionou pra mim. O netbeans não enxergou a função. Fiz algo errado?
END $$;

DROP TABLE IF EXISTS empregado CASCADE;
DROP TABLE IF EXISTS dependente CASCADE;
DROP FUNCTION IF EXISTS generateValues; -- Declarei pois o drop_functions não rolou
DROP FUNCTION IF EXISTS updateAdditionalPerDependent; -- Declarei pois o drop_functions não rolou

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

CREATE OR REPLACE FUNCTION generateValues(INTEGER, INTEGER) RETURNS VOID AS $$
DECLARE
    numberOfEmployees INTEGER:= $1;
    maxDependentsNumber INTEGER:= $2; 
    MAX_SALARY INTEGER:= 5000;
    MAX_ADDITIONAL INTEGER:= 300;
BEGIN
    FOR i IN 1..numberOfEmployees LOOP
        INSERT INTO empregado VALUES(i-1, CONCAT('Empregado ', i), round(random() * MAX_SALARY), round(random() * MAX_ADDITIONAL));
        FOR j IN 1..maxDependentsNumber LOOP
            INSERT INTO dependente VALUES(i-1, j-1, CONCAT('Dependente ', j, ' do empregado ', i));
        END LOOP;
    END LOOP;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION updateAdditionalPerDependent() RETURNS VOID AS $$
DECLARE
    currentEmployee RECORD;
BEGIN
    FOR currentEmployee IN SELECT empregado.empregado_id, COUNT(empregado.empregado_id) as dependentes FROM empregado, dependente WHERE empregado.empregado_id = dependente.empregado_id GROUP BY empregado.empregado_id LOOP
        EXECUTE 'UPDATE empregado SET adicional_dep = adicional_dep * (1 + ($1 * 0.05)) WHERE empregado_id = $2' USING currentEmployee.dependentes, currentEmployee.empregado_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;



DO $$ BEGIN
    PERFORM generateValues(5, 5); -- Criando tabela com 5 empregados e 5 dependetes para cada
END $$;

SELECT * FROM empregado;
SELECT * FROM dependente;

DO $$ BEGIN
    PERFORM updateAdditionalPerDependent();
END $$;

SELECT * FROM empregado ORDER BY (empregado_id);