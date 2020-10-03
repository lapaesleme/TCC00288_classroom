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
    CONSTRAINT empregado_pk PRIMARY KEY (empregado_id)
);

CREATE TABLE dependente (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY (empregado_id) REFERENCES empregado(empregado_id)
);

INSERT INTO empregado VALUES(1, 'Alfredo', 1000, 100);/*100*1,15 = 115*/
INSERT INTO empregado VALUES(2, 'Bob', 2000, 200);/*200*1,1 = 220*/
INSERT INTO empregado VALUES(3, 'Claudio', 3000, 300);/*300*1,05 = 315*/
INSERT INTO empregado VALUES(4, 'Diego', 4000, 400);/*400*1,15 = 460*/
INSERT INTO empregado VALUES(5, 'Eduardo',5000,500);


INSERT INTO dependente VALUES(1, 1, 'AA');
INSERT INTO dependente VALUES(1, 2, 'AB');
INSERT INTO dependente VALUES(1, 3, 'AC');
INSERT INTO dependente VALUES(2, 1, 'BA');
INSERT INTO dependente VALUES(2, 2, 'BB');
INSERT INTO dependente VALUES(3, 1, 'CA');
INSERT INTO dependente VALUES(4, 1, 'DA');
INSERT INTO dependente VALUES(4, 2, 'DB');
INSERT INTO dependente VALUES(4, 3, 'DC');

DROP FUNCTION IF EXISTS atualizaAdicional() CASCADE;

CREATE OR REPLACE FUNCTION  atualizaAdicional() RETURNS VOID
    AS $$
    DECLARE
        num_dependentes integer = 0;
        calc_dep real;
        r RECORD;
    BEGIN
        FOR r IN SELECT * FROM empregado LOOP
                SELECT COUNT (*) FROM dependente WHERE dependente.empregado_id = r.empregado_id
                GROUP BY dependente.empregado_id
                INTO num_dependentes;

                IF num_dependentes > 0 THEN
                    calc_dep = r.adicional_dep;
                    calc_dep = calc_dep * (1 + (num_dependentes * 0.05));
                    UPDATE empregado SET adicional_dep = calc_dep WHERE empregado.empregado_id = r.empregado_id;
                END IF;
           
        END LOOP;           
    END;
$$
LANGUAGE PLPGSQL;

SELECT atualizaAdicional();
SELECT * FROM empregado;