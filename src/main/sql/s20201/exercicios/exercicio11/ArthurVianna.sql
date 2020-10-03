DROP TABLE IF EXISTS produto CASCADE;
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

CREATE TABLE produto(
    codigo int not null,
    nome varchar,
    preco real,

    CONSTRAINT produto_pk PRIMARY KEY (codigo)
);

INSERT INTO produto
    VALUES(0, 'Playstation 5', 400);
INSERT INTO produto
    VALUES(1, 'Guitarra', 300);
INSERT INTO produto
    VALUES(2, 'Bateria', 410);
INSERT INTO produto
    VALUES(3, 'Piano', 900);

CREATE OR REPLACE FUNCTION ajusta_preco10() RETURNS void AS $$
DECLARE
    item RECORD;
    preco_ajustado real;
BEGIN
    FOR item IN (SELECT codigo, preco FROM produto) LOOP
        preco_ajustado := item.preco + item.preco * 0.1;
        UPDATE produto SET preco = preco_ajustado 
        WHERE produto.codigo = item.codigo;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT ajusta_preco10();

/*Valores esperados
Playstation5 440
Guitarra 330
Bateria 451
Piano 990
*/

SELECT * FROM produto;
