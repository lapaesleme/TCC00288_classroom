DROP TABLE IF EXISTS empregado CASCADE;
DROP TABLE IF EXISTS dependente CASCADE;

CREATE TABLE empregado (
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk
        PRIMARY KEY (empregado_id)
);

CREATE TABLE dependente (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk
        PRIMARY KEY (empregado_id, seq),
    CONSTRAINT empregado_fk
        FOREIGN KEY (empregado_id)
        REFERENCES empregado(empregado_id)
);

INSERT INTO empregado VALUES(0, 'Juca', 1000, 1000);
INSERT INTO dependente VALUES(0, 0, 'Juquinha');

INSERT INTO empregado VALUES(1, 'Zeca', 2000, 100);
INSERT INTO dependente VALUES(1, 0, 'Zequinha');
INSERT INTO dependente VALUES(1, 1, 'Zezinho');

-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION atualizar_salario()
RETURNS VOID AS $$
    DECLARE
        novo_adicional REAL;
    
        curs CURSOR FOR
            SELECT DISTINCT empregado.empregado_id, count(*) as n_dependentes, adicional_dep
            FROM empregado, dependente
            WHERE empregado.empregado_id = dependente.empregado_id
            GROUP BY empregado.empregado_id;
    
    BEGIN
        FOR empregado_a_mudar IN curs LOOP
            novo_adicional = empregado_a_mudar.adicional_dep * (1 + empregado_a_mudar.n_dependentes * 0.05);
            UPDATE empregado
            SET adicional_dep = novo_adicional
            WHERE empregado.empregado_id = empregado_a_mudar.empregado_id;
        END LOOP;

    END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------

SELECT DISTINCT empregado.empregado_id, count(*) as n_dependentes, adicional_dep
FROM empregado, dependente
WHERE empregado.empregado_id = dependente.empregado_id
GROUP BY empregado.empregado_id;

SELECT atualizar_salario();

SELECT DISTINCT empregado.empregado_id, count(*) as n_dependentes, adicional_dep
FROM empregado, dependente
WHERE empregado.empregado_id = dependente.empregado_id
GROUP BY empregado.empregado_id;