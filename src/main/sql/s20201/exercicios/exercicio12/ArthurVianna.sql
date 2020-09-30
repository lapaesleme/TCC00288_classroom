DROP TABLE IF EXISTS produto CASCADE;
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

CREATE TABLE produto(
    codigo int not null,
    categoria char,
    preco real,

    CONSTRAINT produto_pk PRIMARY KEY (codigo)
);

INSERT INTO produto
    VALUES(0, 'A', 400);
INSERT INTO produto
    VALUES(1, 'A', 300);
INSERT INTO produto
    VALUES(2, 'B', 410);
INSERT INTO produto
    VALUES(3, 'C', 900);

CREATE OR REPLACE FUNCTION ajusta_preco_ctg() RETURNS void AS $$
DECLARE
    cur REFCURSOR;
    rowvar produto%ROWTYPE;
    preco_ajustado real;
BEGIN
    OPEN cur FOR SELECT * FROM produto;
    LOOP
        FETCH cur INTO rowvar;
        EXIT WHEN NOT FOUND;
        IF rowvar.categoria = 'A' THEN
            preco_ajustado := rowvar.preco + rowvar.preco*0.05;
        ELSIF rowvar.categoria = 'B' THEN
            preco_ajustado := rowvar.preco + rowvar.preco*0.10;
        ELSE
            preco_ajustado := rowvar.preco + rowvar.preco*0.15;
        END IF;
        UPDATE produto SET preco = preco_ajustado 
            WHERE CURRENT OF cur;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT ajusta_preco_ctg();

/*Valores esperados
0 A 420
1 A 315
2 B 451
3 C 1035
*/

SELECT * FROM produto;
