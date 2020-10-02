DROP TABLE IF EXISTS empregado CASCADE;
DROP TABLE IF EXISTS dependente CASCADE;
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

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

INSERT INTO empregado
    VALUES(0, 'Luiz', 1000.00, 0.00);

INSERT INTO empregado
    VALUES(1, 'Alberto', 2000.00, 0.00);

INSERT INTO empregado
    VALUES(2, 'Isabela', 3000.00, 0.00);

INSERT INTO empregado
    VALUES(3, 'Carolina', 4000.00, 0.00);
--dependentes
INSERT INTO dependente
    VALUES(0, 0, 'Arthur');
INSERT INTO dependente
    VALUES(0, 1, 'Henrique');
INSERT INTO dependente
    VALUES(1, 2, 'Mariana');
INSERT INTO dependente
    VALUES(2, 3, 'Heitor');

CREATE OR REPLACE FUNCTION adicional_dep() RETURNS void AS $$
DECLARE
    funcionario RECORD;
    n_dependentes int;
BEGIN
    FOR funcionario IN (SELECT * FROM empregado) LOOP
        n_dependentes := (SELECT COUNT(*) FROM dependente AS d 
            WHERE d.empregado_id = funcionario.empregado_id);
        --adicional = salario * n_dependentes * 0.05
        UPDATE empregado SET
        adicional_dep = funcionario.salario * n_dependentes * 0.05
        WHERE empregado_id = funcionario.empregado_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM adicional_dep();

/*Valores esperados
Luiz adicional_dep = 100
Alberto adicional_dep = 100
isabela adicional_dep = 150
Carolina adicional_dep = 0
*/

SELECT * FROM
(SELECT * FROM empregado) t1 
NATURAL JOIN
(SELECT COUNT(*) AS n_dependentes, empregado_id FROM dependente GROUP BY empregado_id) t2;
