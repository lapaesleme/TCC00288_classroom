/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 22 de set. de 2020
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


CREATE OR REPLACE FUNCTION excluirLinha (mat int[][], linha int)
    RETURNS int[][]
    AS $$
    DECLARE       
        matriz_rows int;
        matriz_cols int;
        matriz_final int[][];
        linha_append int[];

    BEGIN
        SELECT array_length(mat, 1) INTO matriz_rows;
        SELECT array_length(mat, 2) INTO matriz_cols;

        IF matriz_rows < linha THEN
            RAISE EXCEPTION 'O indice da linha a ser excluida é maior que o numero de linhas da matriz';
        END IF;

        FOR i IN 1..matriz_rows LOOP
            IF i != linha THEN
                FOR j IN 1..matriz_cols LOOP
                    linha_append[j] = mat[i][j];
                    RAISE NOTICE 'Valor adicionada: %', mat[i][j];
                END LOOP;
                matriz_final = array_cat(matriz_final, ARRAY[linha_append]); 
                RAISE NOTICE 'Array adicionado: %', linha_append;
            END IF;
        END LOOP;

        RETURN matriz_final;
    END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION excluirColuna (mat int[][], coluna int)
    RETURNS int[][]
    AS $$
    DECLARE       
        matriz_rows int;
        matriz_cols int;
        matriz_final int[][];
        linha_append int[];
        aux int = 1;

    BEGIN
        SELECT array_length(mat, 1) INTO matriz_rows;
        SELECT array_length(mat, 2) INTO matriz_cols;

        IF matriz_cols < coluna THEN
            RAISE EXCEPTION 'O indice da coluna a ser excluida é maior que o numero de coluas da matriz';
        END IF;        

        FOR i IN 1..matriz_rows LOOP
            aux = 0;
            FOR j IN 1..matriz_cols LOOP
                IF j != coluna THEN
                    aux:= aux +1;
                    linha_append[aux] = mat[i][j];
                END IF;
            END LOOP;
            matriz_final = array_cat(matriz_final, ARRAY[linha_append]); 
        END LOOP;

        RETURN matriz_final;
    END;
$$
LANGUAGE PLPGSQL;


--{{4,5,6}}
SELECT excluirLinha(matriz, 1) FROM matriz1;

--{{4,2},{2,4}}
SELECT excluirLinha(matriz, 3) FROM matriz2;

--{{1,2,3},{7,8,9}}
SELECT excluirLinha(matriz, 2) FROM matriz4;

-- ERROR: O indice da linha a ser excluida é maior que o numero de linhas da matriz
SELECT excluirLinha(matriz, 3) FROM matriz1;

--{{2,3},{5,6}}
SELECT excluirColuna(matriz, 1) FROM matriz1;

--{{4},{2},{3}}
SELECT excluirColuna(matriz, 2) FROM matriz2;

--{{1,3},{4,6},{7,9}}
SELECT excluirColuna(matriz, 2) FROM matriz4;

-- ERROR: O indice da coluna a ser excluida é maior que o numero de coluas da matriz
SELECT excluirColuna(matriz, 4) FROM matriz1;