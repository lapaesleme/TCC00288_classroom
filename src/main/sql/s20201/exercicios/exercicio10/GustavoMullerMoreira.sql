DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists empregado cascade;
drop table if exists dependente cascade;

CREATE TABLE empregado (
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY (empregado_id)
);

CREATE TABLE dependente (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY (empregado_id) REFERENCES empregado (empregado_id)
);

INSERT INTO empregado VALUES (1, 'Joao', 1200, 200);
INSERT INTO empregado VALUES (2, 'Maria', 3000, 500);

INSERT INTO dependente VALUES (1, 123, 'Roberto');
INSERT INTO dependente VALUES (1, 321, 'Jonas');
INSERT INTO dependente VALUES (1, 312, 'Joana');

INSERT INTO dependente VALUES (2, 231, 'Gabriel');
INSERT INTO dependente VALUES (2, 213, 'Patricia');


CREATE or REPLACE FUNCTION attAdicional() RETURNS void AS $$
DECLARE
    dep_emp RECORD;
BEGIN
    
    FOR dep_emp IN SELECT e.empregado_id, COUNT(e.empregado_id) as num_dependentes FROM empregado as e, dependente as d WHERE e.empregado_id = d.empregado_id GROUP BY e.empregado_id
    LOOP
        /* Acho que existe uma incroguencia no enunciado da questao, eh pedido 5% de ajuste mas a formula apresenta 0,5%*/
        EXECUTE 'UPDATE empregado SET adicional_dep = adicional_dep * (1 + $1 * 0.05) WHERE empregado_id = $2' USING dep_emp.num_dependentes, dep_emp.empregado_id;
    END LOOP;

END;
$$ LANGUAGE plpgsql;

DO $$ BEGIN
    PERFORM attAdicional();
END $$;

SELECT * FROM empregado; 
