/*
Autor: João Victor Simonassi
22/09/2020

*/

DROP FUNCTION IF EXISTS multiplyMatrix;
DROP FUNCTION IF EXISTS generateMatrix;

CREATE FUNCTION generateMatrix() RETURNS float[][] AS $$
    /*Esta função gera matrizes aleatórias*/
    DECLARE 
        nRows INTEGER;
        nColumns INTEGER;
        temp FLOAT;
        MAX_SIZE INTEGER:= 4; -- Tamanho máximo da matriz - 1 (Linha ou coluna)
        MAX_VALUE INTEGER:= 10; -- Valor máximo que um elemento da matriz pode assumir
        response float[][];
    BEGIN
        SELECT round(random() * MAX_SIZE + 1) INTO nRows;
        SELECT round(random() * MAX_SIZE + 1) INTO nColumns;
        response := array_fill(null::float, ARRAY[nRows,nColumns]);

        FOR i IN 1..nRows LOOP 
            FOR j IN 1..nColumns LOOP
                SELECT round(random() * MAX_VALUE) INTO temp; -- Dúvida aqui: Como gerar decimais?
                response[i][j] := temp;
            END LOOP;
        END LOOP;
    RETURN response;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION multiplyMatrix(FLOAT[][], FLOAT[][]) RETURNS FLOAT[][] AS $$
    DECLARE
        matrix1 FLOAT[][]:= ($1);
        matrix2 FLOAT[][]:= ($2);
        response FLOAT[][];
        accumulator FLOAT:=0;
    BEGIN
        RAISE NOTICE 'Matriz 1: %', matrix1;
        RAISE NOTICE 'Matriz 2: %', matrix2;
        IF(array_length(matrix1, 2)!= array_length(matrix2, 1)) THEN
            RAISE EXCEPTION 'O número de colunas da 1ª matriz deve ser igual
                             ao número de linhas da 2ª matriz';
            -- RETURN null;
        END IF;
        response := array_fill(null::float, ARRAY[array_length(matrix1, 1),array_length(matrix2, 2)]);
        FOR i IN 1..array_length(matrix1, 1) LOOP
            FOR j IN 1..array_length(matrix2, 2) LOOP
                accumulator:= 0;
                FOR k IN 1..array_length(matrix1, 2) LOOP
                    accumulator=accumulator+matrix1[i][k]*matrix2[k][j];
                END LOOP;
                response[i][j]=accumulator;
            END LOOP;
        END LOOP;
    RETURN response;
END;
$$ LANGUAGE plpgsql;

select multiplyMatrix(generateMatrix(), generateMatrix());
