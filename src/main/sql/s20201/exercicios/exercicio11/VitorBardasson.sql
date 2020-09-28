DROP TABLE IF EXISTS produto;

CREATE TABLE produto (
    codigo integer UNIQUE NOT NULL,
    nome varchar NOT NULL,
    preco float
);

INSERT INTO produto VALUES (1, 'Celular', 1000);
INSERT INTO produto VALUES (2, 'Computador', 2000);
INSERT INTO produto VALUES (3, 'TV', 2500);
INSERT INTO produto VALUES (4, 'Mouse', 50);
INSERT INTO produto VALUES (5, 'Carregador', 39.90);

SELECT drop_functions();

CREATE OR REPLACE FUNCTION reajustar() RETURNS void AS $$
    DECLARE
        curs1 CURSOR FOR SELECT codigo FROM produto;
        t_row record;
        cur_cod integer;
        updated_price float;
        
    BEGIN
        OPEN curs1 ;

        LOOP
            FETCH curs1 INTO t_row;
            EXIT WHEN NOT FOUND;
            SELECT preco*1.1 FROM produto INTO updated_price;
            RAISE NOTICE '%', updated_price;
            UPDATE produto SET preco = round((preco * 1.1)::decimal, 2) WHERE CURRENT OF curs1;  
        END LOOP;

        CLOSE curs1;
    END;
$$
LANGUAGE PLPGSQL;

SELECT reajustar();
SELECT * FROM produto;