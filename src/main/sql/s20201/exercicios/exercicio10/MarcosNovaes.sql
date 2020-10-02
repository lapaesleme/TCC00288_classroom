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


-- INSERT
INSERT INTO empregado VALUES(0, 'CARLOS', 1000, 70);
INSERT INTO dependente VALUES(0, 0, 'RENATO');

INSERT INTO empregado VALUES(1, 'SERGIO', 2000, 100);
INSERT INTO dependente VALUES(1, 1, 'MARCOS');
INSERT INTO dependente VALUES(1, 2, 'PEDRO');

INSERT INTO empregado VALUES(2, 'TEVES', 1500, 200);

INSERT INTO empregado VALUES(3, 'CLARA', 2000, 10);
INSERT INTO dependente VALUES(3, 3, 'JOAO');
INSERT INTO dependente VALUES(3, 4, 'DEBORA');
INSERT INTO dependente VALUES(3, 5, 'MARIA');


DROP FUNCTION IF EXISTS atualizaAddDep() CASCADE;

CREATE OR REPLACE FUNCTION atualizaAddDep()
    RETURNS VOID
    AS $$
    DECLARE
        linhaAtual RECORD;
        numDeps integer default 0;
        addDep float default 0;
    BEGIN
        FOR linhaAtual IN SELECT * FROM empregado LOOP
            SELECT COUNT(*) INTO numDeps FROM dependente WHERE empregado_id = linhaAtual.empregado_id;
            addDep := round((linhaAtual.adicional_dep * (1 + numDeps * 0.05))::numeric, 2);
            UPDATE empregado SET adicional_dep = addDep WHERE empregado_id = linhaAtual.empregado_id;
        END LOOP;    
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM empregado;

DO $$ BEGIN
    PERFORM atualizaAddDep();
END $$;

SELECT * FROM empregado;