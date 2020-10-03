DROP TABLE IF EXISTS empregado CASCADE;
DROP TABLE IF EXISTS dependente;

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

INSERT INTO empregado VALUES (1, 'João', 1000, 50);
INSERT INTO empregado VALUES (2, 'Maria', 1500, 100);
INSERT INTO empregado VALUES (3, 'Carlos', 2000, 0);
INSERT INTO empregado VALUES (4, 'Paula', 2200, 150);

/*CONSIDEREI 50 REAIS DE ADICIONAL POR DEPENDENTE*/

INSERT INTO dependente VALUES (1, 0, 'Enzo');
INSERT INTO dependente VALUES (2, 1, 'Beatriz');
INSERT INTO dependente VALUES (2, 2, 'Matheus');
INSERT INTO dependente VALUES (4, 3, 'Valentina');
INSERT INTO dependente VALUES (4, 4, 'Isabel');
INSERT INTO dependente VALUES (4, 5, 'Alice');


SELECT drop_functions();

CREATE OR REPLACE FUNCTION atualizar() RETURNS void AS $$
    DECLARE
        curs1 CURSOR FOR SELECT empregado_id FROM empregado;
        t_row record;
        n_dependentes integer;
        cur_id integer;
        
    BEGIN
        OPEN curs1 ;

        LOOP
            FETCH curs1 into t_row;
            EXIT WHEN NOT FOUND;
            SELECT t_row.empregado_id INTO cur_id;
            SELECT COUNT(*) FROM dependente WHERE empregado_id = cur_id INTO n_dependentes;
            UPDATE empregado SET adicional_dep = adicional_dep * (1 +  (n_dependentes * 0.05)) WHERE CURRENT OF curs1;
        END LOOP;

        CLOSE curs1;
    END;
$$
LANGUAGE PLPGSQL;

SELECT atualizar();
SELECT * FROM empregado;