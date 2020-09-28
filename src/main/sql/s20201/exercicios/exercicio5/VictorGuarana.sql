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

CREATE OR REPLACE FUNCTION excluirLinhaColuna (mat int[][], linha int, coluna int)
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

        IF matriz_cols < coluna or matriz_rows < linha THEN
            RAISE EXCEPTION 'O indice está fora de alcance';
        END IF;        

        FOR i IN 1..matriz_rows LOOP
            aux = 0;

            IF i != linha THEN
            FOR j IN 1..matriz_cols LOOP
                IF j != coluna THEN
                    aux:= aux +1;
                    linha_append[aux] = mat[i][j];
                END IF;
            END LOOP;
                matriz_final = array_cat(matriz_final, ARRAY[linha_append]); 
            END IF;
        END LOOP;

        RETURN matriz_final;
    END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION determinante (mat int[][])
    RETURNS int
    AS $$
    DECLARE       
        matriz_rows int;
        matriz_cols int;
        resultado int = 0;
        submatriz int[][];

    BEGIN
        SELECT array_length(mat, 1) INTO matriz_rows;
        SELECT array_length(mat, 2) INTO matriz_cols;

        IF matriz_rows != matriz_cols THEN
            RAISE EXCEPTION 'A matriz informada não é uma mariz quadrada';
        END IF;

        IF matriz_rows > 2 THEN
            -- Reduz matriz
            -- Chama deterninante
            FOR i IN 1..matriz_rows LOOP
                submatriz = excluirLinhaColuna(mat, 1, i);
                resultado := resultado + ((-1) ^ (1 + i) * mat[1][i]
                            * determinante(submatriz));
            END LOOP;

        ELSE 
            -- Faz determinante 2x2
            resultado := (mat[1][1] * mat[2][2]) - (mat[2][1] * mat[1][2]);
        END IF;

        RETURN resultado;
    END;
$$
LANGUAGE PLPGSQL;


--ERROR: A matriz informada não é uma mariz quadrada
SELECT determinante(matriz) FROM matriz1;

--40
SELECT determinante(matriz) FROM matriz3;

--0
SELECT determinante(matriz) FROM matriz4;