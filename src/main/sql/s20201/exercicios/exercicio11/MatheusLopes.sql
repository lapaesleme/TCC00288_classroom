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

CREATE TABLE PRODUTO (
    codigo integer NOT NULL,
    nome character varying NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk PRIMARY KEY
        (codigo)
);

INSERT INTO PRODUTO VALUES (1, 'produto1', 1);
INSERT INTO PRODUTO VALUES (2, 'produto2', 2);
INSERT INTO PRODUTO VALUES (3, 'produto3', 5);

CREATE OR REPLACE FUNCTION reajusteDePreco () RETURNS void AS $$
    DECLARE 
    PROD PRODUTO;
    
    BEGIN
        FOR PROD IN SELECT * FROM PRODUTO LOOP
            UPDATE PRODUTO 
                SET preco = preco*1.1
            WHERE PRODUTO.codigo = PROD.codigo;
        END LOOP;
    END
$$ LANGUAGE plpgsql;

SELECT reajusteDePreco();
SELECT * FROM PRODUTO;