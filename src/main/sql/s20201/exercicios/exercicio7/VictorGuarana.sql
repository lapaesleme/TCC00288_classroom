/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 23 de set. de 2020
 * Task: Transpor Matriz
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


CREATE OR REPLACE FUNCTION transporMatriz (matriz float[][])
    RETURNS float[][]
    AS $$
    DECLARE       
        matriz_rows int;
        matriz_cols int;
        matriz_transposta float[][];

    BEGIN
        SELECT array_length(matriz, 1) INTO matriz_rows;
        SELECT array_length(matriz, 2) INTO matriz_cols;  
        SELECT array_fill(0, ARRAY[matriz_cols, matriz_rows]) INTO matriz_transposta;
        
        FOR i IN 1..matriz_rows LOOP
            FOR j IN 1..matriz_cols LOOP
                matriz_transposta[j][i] = matriz[i][j];
            END LOOP;
        END LOOP;

        RETURN matriz_transposta;
    END;
$$
LANGUAGE PLPGSQL;

--{{1,4},{2,5},{3,6}}
SELECT transporMatriz(matriz) FROM matriz1;

--{{4,2,3},{2,4,5}}
SELECT transporMatriz(matriz) FROM matriz2;

--{{1,4,7},{2,5,8},{3,6,9}}
SELECT transporMatriz(matriz) FROM matriz4;
