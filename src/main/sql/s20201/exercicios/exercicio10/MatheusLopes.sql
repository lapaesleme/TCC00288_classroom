/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  mathe
 * Created: 28/09/2020
 */

DO $$ BEGIN
    PERFORM drop_functions();
END $$;


DROP TABLE IF EXISTS EMPREGADO CASCADE;
DROP TABLE IF EXISTS DEPENDENTE CASCADE;

CREATE TABLE EMPREGADO (
    empregado_id integer NOT NULL,
    nome character varying NOT NULL,
    salario real NOT NULL,
    adicional_dep real NOT NULL,
    CONSTRAINT empregado_pk PRIMARY KEY
        (empregado_id)
);
INSERT INTO EMPREGADO VALUES (1,'empregado1', 1000, 100);
INSERT INTO EMPREGADO VALUES (2, 'empregado2', 2000, 200);
INSERT INTO EMPREGADO VALUES (3, 'empregado3', 3000, 300);


CREATE TABLE DEPENDENTE (
    empregado_id integer NOT NULL,
    seq smallint NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT dependente_pk PRIMARY KEY
        (empregado_id, seq),
    CONSTRAINT empregado_fk FOREIGN KEY
        (empregado_id) REFERENCES empregado(empregado_id)
);

INSERT INTO DEPENDENTE VALUES (1, 1, 'dependente1');
INSERT INTO DEPENDENTE VALUES (1, 2, 'dependente2');
INSERT INTO DEPENDENTE VALUES (1, 3, 'dependente3');
INSERT INTO DEPENDENTE VALUES (2, 1, 'dependente4');
INSERT INTO DEPENDENTE VALUES (2, 2, 'dependente5');
INSERT INTO DEPENDENTE VALUES (3, 1, 'dependente6');


CREATE OR REPLACE FUNCTION adicionalDep() RETURNS void AS $$ 
    DECLARE 
        num_dep integer;
        EMP EMPREGADO;
    BEGIN
        FOR EMP IN SELECT * FROM EMPREGADO LOOP
            SELECT COUNT(*) FROM DEPENDENTE
                WHERE DEPENDENTE.empregado_id = EMP.empregado_id 
                    GROUP BY DEPENDENTE.empregado_id INTO num_dep;
            UPDATE EMPREGADO 
                SET adicional_dep = adicional_dep * (1+(num_dep*0.05))
                    WHERE EMPREGADO.empregado_id = EMP.empregado_id;
        END LOOP;
    END
$$ LANGUAGE plpgsql;

SELECT adicionalDep();
SELECT * FROM EMPREGADO;
