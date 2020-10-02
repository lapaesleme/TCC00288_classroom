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

DROP TABLE IF EXISTS PRODUTO CASCADE;

CREATE TABLE PRODUTO(
    codigo integer NOT NULL,
    categoria varchar NOT NULL,
    valor real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY (codigo)
);

INSERT INTO PRODUTO VALUES (1, 'categoria A', 1);
INSERT INTO PRODUTO VALUES (2, 'categoria A', 2);
INSERT INTO PRODUTO VALUES (3, 'categoria B', 3);
INSERT INTO PRODUTO VALUES (4, 'categoria B', 4);
INSERT INTO PRODUTO VALUES (5, 'categoria C', 5);
INSERT INTO PRODUTO VALUES (6, 'categoria A', 6);

CREATE OR REPLACE FUNCTION reajuste_por_categoria () RETURNS void AS $$
    DECLARE
        PROD PRODUTO;
        val float;
    BEGIN
        
        FOR PROD IN SELECT * FROM PRODUTO LOOP
            IF PROD.categoria =  'categoria A' THEN val := 0.05;
            ElSIF PROD.categoria = 'categoria B' THEN val := 0.1;
            ELSIF PROD.categoria = 'categoria C' THEN val := 0.15;
            END IF;
            UPDATE PRODUTO 
                SET valor = valor*(1+ val)
                    WHERE PRODUTO.codigo = PROD.codigo;
        END LOOP;
        
    END
$$ LANGUAGE plpgsql;

SELECT reajuste_por_categoria();
SELECT * FROM PRODUTO;