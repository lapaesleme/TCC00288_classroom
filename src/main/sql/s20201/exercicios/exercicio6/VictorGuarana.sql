/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 23 de set. de 2020
 */

Drop table if exists matriz1;
Drop table if exists matriz2;
Drop table if exists matriz3;
Drop table if exists matriz4;


Create table matriz1 (
    matriz int[][]
);
Create table matriz2 (
    matriz int[][]
);
Create table matriz3 (
    matriz int[][]
);
Create table matriz4 (
    matriz int[][]
);

Insert into matriz1 values (Array[[1, 2, 3], [4, 5, 6]]);
Insert into matriz2 values (Array[[4, 2], [2, 4], [3, 5]]);
Insert into matriz3 values (Array[[4, 2, 3], [2, 4, 5], [7, 3, 8]]);
Insert into matriz4 values (Array[[1, 2, 3], [4, 5, 6], [7, 8, 9]]);

DROP FUNCTION operarlinhascolunas(integer[],integer,integer,integer,integer);

CREATE OR REPLACE FUNCTION operarLinhasColunas (mat int[][], linha_alvo int, linha_adicional int, c1 int, c2 int)
    RETURNS int[][]
    AS $$
    DECLARE       
        matriz_rows int;
        matriz_cols int;

    BEGIN
        SELECT array_length(mat, 1) INTO matriz_rows;
        SELECT array_length(mat, 2) INTO matriz_cols;

        IF matriz_rows < linha_alvo or matriz_rows < linha_adicional THEN
            RAISE EXCEPTION 'O indice está fora de alcance';
        END IF;        
        
        FOR i IN 1..matriz_cols LOOP
            mat[linha_alvo][i] = c1 * mat[linha_alvo][i] + c2 * mat[linha_adicional][i];
        END LOOP;

        RETURN mat;
    END;
$$
LANGUAGE PLPGSQL;

--{{17,25,33},{4,5,6}}
SELECT operarLinhasColunas(matriz, 1, 2, 5, 3) FROM matriz1;

--{{34,38},{2,4},{3,5}}
SELECT operarLinhasColunas(matriz, 1, 3, 4, 6) FROM matriz2;

--{{4,2,3},{22,26,34},{7,3,8}}
SELECT operarLinhasColunas(matriz, 2, 1, 5, 3) FROM matriz3;

--{{1,2,3},{4,5,6},{30,36,42}}
SELECT operarLinhasColunas(matriz, 3, 2, 2, 4) FROM matriz4;

--ERROR: O indice está fora de alcance
SELECT operarLinhasColunas(matriz, 4, 1, 5, 3) FROM matriz4;