/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 21 de set. de 2020
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


CREATE OR REPLACE FUNCTION multiplicarMatrizes (matriz1 float[][], matriz2 float[][])
    RETURNS int[][]
    AS $$
    DECLARE
        matriz1_row int;
        matriz1_col int; 
        matriz2_row int; 
        matriz2_col int;
        matriz_resultante int[][];

    BEGIN
        SELECT array_length(matriz1, 2) INTO matriz1_row;
        SELECT array_length(matriz1, 1) INTO matriz1_col;
        SELECT array_length(matriz2, 2) INTO matriz2_row;
        SELECT array_length(matriz2, 1) INTO matriz2_col;
        SELECT array_fill(0, ARRAY[matriz1_col, matriz2_row]) INTO matriz_resultante;
        IF matriz1_row != matriz2_col THEN
            RAISE EXCEPTION 'O número de colunas da matriz da esquerda deve ser igual número de linhas da matriz da direita.';
        END IF;

        FOR i IN 1..matriz1_col LOOP
            FOR j IN 1..matriz2_row LOOP
                FOR k IN 1..matriz1_row LOOP
                    matriz_resultante[i][j] := matriz_resultante[i][j] + (matriz1[i][k] * matriz2[k][j]);
                END LOOP;
            END LOOP;
        END LOOP;

        RETURN matriz_resultante;
    END;
$$
LANGUAGE PLPGSQL;


--{{17,25},{44,58}}
SELECT multiplicarMatrizes(matriz1.matriz, matriz2.matriz) FROM matriz1, matriz2;

--{{12,18,24},{18,24,30},{23,31,39}}
SELECT multiplicarMatrizes(matriz2.matriz, matriz1.matriz) FROM matriz1, matriz2;

--{{29,19,37},{68,46,85},{107,73,133}}
SELECT multiplicarMatrizes(matriz4.matriz, matriz3.matriz) FROM matriz4, matriz3;

--{{29,19,37},{68,46,85}}
SELECT multiplicarMatrizes(matriz1.matriz, matriz3.matriz) FROM matriz1, matriz3;

--ERROR: O número de colunas da matriz da esquerda deve ser igual número de linhas da matriz da direita.
SELECT multiplicarMatrizes(matriz2.matriz, matriz3.matriz) FROM matriz2, matriz3;
