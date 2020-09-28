DROP TABLE IF EXISTS produto;
DROP TYPE IF EXISTS categoria_enum;

CREATE TYPE categoria_enum AS ENUM ('A', 'B', 'C');

CREATE TABLE produto (
    codigo integer UNIQUE NOT NULL,
    categoria categoria_enum NOT NULL,
    valor float,
    CONSTRAINT produto_pk PRIMARY KEY (codigo)
);

INSERT INTO produto VALUES (1, 'A', 1000);
INSERT INTO produto VALUES (2, 'B', 2000);
INSERT INTO produto VALUES (3, 'C', 2500);
INSERT INTO produto VALUES (4, 'B', 50);
INSERT INTO produto VALUES (5, 'A', 39.90);

SELECT drop_functions();

CREATE OR REPLACE FUNCTION reajustarcategoria() RETURNS void AS $$
    DECLARE
        curs1 CURSOR FOR SELECT categoria FROM produto;
        t_row record;
        cur_cat char;
        factor float;
        
    BEGIN
        OPEN curs1 ;

        LOOP
            FETCH curs1 INTO t_row;
            EXIT WHEN NOT FOUND;
            SELECT t_row.categoria INTO cur_cat;
            IF cur_cat = 'A' THEN factor := 1.05;
            ELSIF cur_cat = 'B' THEN factor := 1.1;
            ELSE factor := 1.15;
            END IF;
            UPDATE produto SET valor = round((valor*factor)::decimal, 2) WHERE CURRENT OF curs1;
        END LOOP;
        CLOSE curs1;
    END;
$$
LANGUAGE PLPGSQL;

SELECT reajustarcategoria();
SELECT * FROM produto;