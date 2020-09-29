DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE if exists empregado cascade;
DROP TABLE if exists dependente cascade;

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

INSERT INTO empregado (empregado_id, nome, salario, adicional_dep)
VALUES (1, 'João', 3500.0, 1000.0);

INSERT INTO empregado (empregado_id, nome, salario, adicional_dep)
VALUES (2, 'Maria', 6500.0, 1000.0);

INSERT INTO dependente (empregado_id, seq, nome)
VALUES (1, 1, 'Marcos');

INSERT INTO dependente (empregado_id, seq, nome)
VALUES (1, 2, 'Jonas');

INSERT INTO dependente (empregado_id, seq, nome)
VALUES (2, 3, 'Pedro');

INSERT INTO dependente (empregado_id, seq, nome)
VALUES (2, 4, 'Roberto');

INSERT INTO dependente (empregado_id, seq, nome)
VALUES (2, 5, 'Carlos');

CREATE OR REPLACE FUNCTION update_additional_income() RETURNS void as $$
DECLARE
    employee empregado%rowtype;
    number_dependents integer;
    value_dependents float;
BEGIN
    FOR employee in SELECT * FROM empregado LOOP
        SELECT COUNT(*) INTO number_dependents FROM dependente WHERE empregado_id = employee.empregado_id;

        value_dependents := employee.adicional_dep * (1 + number_dependents * 0.005);

        EXECUTE 'UPDATE empregado
        SET adicional_dep = $1
        WHERE empregado_id = $2' USING value_dependents, employee.empregado_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;

-- SELECT * FROM empregado;

SELECT * FROM update_additional_income();

-- SELECT * FROM empregado;