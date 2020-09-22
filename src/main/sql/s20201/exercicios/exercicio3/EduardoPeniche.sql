
DROP TABLE IF EXISTS matriz1 CASCADE;
DROP TABLE IF EXISTS matriz2 CASCADE;
DROP TABLE IF EXISTS matriz_erro CASCADE;
DROP TABLE IF EXISTS matriz_res CASCADE;

CREATE TABLE matriz1 (
    elementos float[][]
);
CREATE TABLE matriz2 (
    elementos float[][]
);
CREATE TABLE matriz_erro (
    elementos float[][]
);
CREATE TABLE matriz_res (
    elementos float[][]
);

INSERT INTO  matriz1 (elementos) VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);
INSERT INTO matriz2 (elementos) VALUES (ARRAY[[2],[3],[4]]);
INSERT INTO matriz_erro(elementos) VALUES (ARRAY[[1],[2]]);

SELECT * FROM matriz1;
SELECT * FROM matriz2;
SELECT * FROM matriz_erro;

DROP FUNCTION IF EXISTS multiMatriz( float[][], float[][] ) CASCADE;

CREATE FUNCTION multiMatriz(matriz1 float[][],matriz2 float[][]) RETURNS float [][] 
    AS $$
    DECLARE
        numLinMat1 integer;
        numColMat1 integer;
        numLinMat2 integer;
        numColMat2 integer;
        matriz_res float[][];
    BEGIN
        SELECT array_length(matriz1, 1) INTO numLinMat1;
        SELECT array_length(matriz1, 2) INTO numColMat1;
        SELECT array_length(matriz2, 1) INTO numLinMat2;
        SELECT array_length(matriz2, 2) INTO numColMat2;
        SELECT array_fill(0,ARRAY[numLinMat1,numColMat2]) INTO matriz_res;
        
        IF numColMat1 != numLinMat2 THEN
            RAISE EXCEPTION 'Matrizes incompatíveis para multiplicação.';
        END IF;

        FOR i IN 1.. numLinMat1 LOOP
            FOR j IN 1..numColMat2 LOOP
               FOR k IN 1..numLinMat2 LOOP
                matriz_res[i][j] := matriz_res[i][j] + (matriz1[i][k] * matriz2[k][j]);
               END LOOP;
            END LOOP;
        END LOOP;
        RETURN matriz_res;
    END;
$$
LANGUAGE PLPGSQL;

SELECT multiMatriz(matriz1.elementos, matriz2.elementos) FROM matriz1, matriz2;

SELECT multiMatriz (matriz1.elementos, matriz_erro.elementos) FROM matriz1, matriz_erro;







