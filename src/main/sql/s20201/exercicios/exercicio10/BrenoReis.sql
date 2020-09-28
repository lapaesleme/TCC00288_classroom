DROP TABLE IF EXISTS dependente CASCADE;
DROP TABLE IF EXISTS empregado CASCADE;

CREATE TABLE empregado(
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY(empregado_id)
);

CREATE TABLE dependente(
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY(empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY(empregado_id) REFERENCES empregado(empregado_id)
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

DROP FUNCTION IF EXISTS ajustaAdicional();
CREATE FUNCTION ajustaAdicional()
    RETURNS Boolean as $$
    DECLARE
        linhaTabela RECORD;
        qtdDependente integer := 0;
    BEGIN
        FOR linhaTabela IN SELECT DISTINCT empregado.empregado_id, empregado.adicional_dep 
                            FROM empregado INNER JOIN dependente 
                            ON(empregado.empregado_id = dependente.empregado_id) LOOP

            SELECT COUNT(dependente.empregado_id) 
            FROM empregado JOIN dependente 
            ON(empregado.empregado_id = dependente.empregado_id) 
            WHERE dependente.empregado_id = linhaTabela.empregado_id 
            GROUP BY dependente.empregado_id 
            INTO qtdDependente;

            RAISE NOTICE 'Empregado da Vez: %, Quantidade de Dependentes: %, Novo Adicional: %', linhaTabela.empregado_id, qtdDependente, linhaTabela.adicional_dep;

            UPDATE empregado SET adicional_dep = adicional_dep * (1 + (0.05*qtdDependente)) WHERE empregado_id = linhaTabela.empregado_id;
        END LOOP;
        RETURN TRUE;
    END;
$$
LANGUAGE PLPGSQL;

SELECT ajustaAdicional();
SELECT * FROM empregado ORDER BY empregado_id;
