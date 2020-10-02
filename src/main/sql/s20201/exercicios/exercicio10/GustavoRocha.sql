
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

INSERT INTO empregado(empregado_id, nome, salario, adicional_dep) VALUES(1, 'AA', 1000, 200);
INSERT INTO empregado(empregado_id, nome, salario, adicional_dep) VALUES(2, 'AB', 1250, 300);
INSERT INTO empregado(empregado_id, nome, salario, adicional_dep) VALUES(3, 'AC', 2000, 450);
INSERT INTO empregado(empregado_id, nome, salario, adicional_dep) VALUES(4, 'AD', 1500, 150);
INSERT INTO empregado(empregado_id, nome, salario, adicional_dep) VALUES(5, 'AE', 1700, 300);

INSERT INTO dependente(empregado_id, seq, nome) VALUES(1, 1, 'BA');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(1, 2, 'BB');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(1, 3, 'BC');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(2, 1, 'CA');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(2, 2, 'CB');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(3, 1, 'DA');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(4, 1, 'EA');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(4, 2, 'EB');
INSERT INTO dependente(empregado_id, seq, nome) VALUES(4, 3, 'EC');

DROP FUNCTION IF EXISTS atualizaDep();

CREATE OR REPLACE FUNCTION atualiza_dep() RETURNS void AS $$
DECLARE
    num_dep integer := 0;
    vetor_emp integer[];
    dep_total integer;
    dependente_aux RECORD;
BEGIN
    FOR dependente_aux IN SELECT DISTINCT empregado_id FROM dependente ORDER BY empregado_id LOOP
        vetor_emp := array_append(vetor_emp, dependente_aux.empregado_id);
    END LOOP;
    SELECT array_length(vetor_emp,1) INTO dep_total;
    RAISE NOTICE 'total de dependentes: %',dep_total;
    FOR i IN 1..dep_total LOOP
        SELECT COUNT(empregado_id) FROM dependente WHERE empregado_id = vetor_emp[i] GROUP BY empregado_id INTO num_dep;
        UPDATE empregado SET adicional_dep = adicional_dep * (1 + (num_dep * 0.05)) WHERE empregado.empregado_id = vetor_emp[i];
    END LOOP;
END;
$$
LANGUAGE PLPGSQL;

SELECT atualiza_dep();
SELECT * FROM empregado;

SELECT empregado_id FROM dependente ORDER BY empregado_id;