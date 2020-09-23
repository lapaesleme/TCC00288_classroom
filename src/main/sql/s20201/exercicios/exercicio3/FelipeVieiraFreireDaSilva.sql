DROP TABLE IF EXISTS matriz1;

DROP TABLE IF EXISTS matriz2;

DROP TABLE IF EXISTS matriz3;

CREATE TABLE matriz1
(
    valores float[][]
);
CREATE TABLE matriz2
(
    valores float[][]
);
CREATE TABLE matriz3
(
    valores float[][]
);

INSERT INTO matriz1 (valores) 
VALUES (ARRAY[[1, 1, 1],[2, 2, 2],[3, 3, 3]]); 

INSERT INTO matriz2 (valores) 
VALUES (ARRAY[[1],[1], [1]]);

INSERT INTO matriz3 (valores) 
VALUES (ARRAY[[5, 5, 5, 5], [5, 5, 5, 5]]);

CREATE OR REPLACE FUNCTION mat_mult (matriz1 float[][], matriz2 float[][])
    RETURNS float[][]
    AS $$
    DECLARE
        qtdLinMat1 integer;
        qtdColMat1 integer;
        qtdLinMat2 integer;
        qtdColMat2 integer;
        matFinal float[][];
    BEGIN
        SELECT array_length(matriz1, 1) INTO qtdLinMat1;
        SELECT array_length(matriz1, 2) INTO qtdColMat1;
        SELECT array_length(matriz2, 1) INTO qtdLinMat2;
        SELECT array_length(matriz2, 2) INTO qtdColMat2;
        SELECT array_fill(0, ARRAY[qtdLinMat1, qtdColMat2]) INTO matFinal;
        IF qtdColMat1 != qtdLinMat2 THEN
            RAISE EXCEPTION 'Quantidade de colunas da Matriz1 diferente da quantidade de linhas da Matriz2';
        END IF;
        FOR i IN 1..qtdLinMat1 LOOP
            FOR j IN 1..qtdColMat2 LOOP
                FOR k IN 1..qtdLinMat2 LOOP
                    matFinal[i][j] := matFinal[i][j] + matriz1[i][k] * matriz2[k][j];
                END LOOP;
            END LOOP;
        END LOOP;
        RETURN matFinal;
    END;
$$
    LANGUAGE PLPGSQL;

--DÁ CERTO SELECT mat_mult(matriz1.valores, matriz2.valores) FROM matriz1, matriz2;

--DÁ ERRO SELECT mat_mult(matriz1.valores, matriz3.valores) FROM matriz1, matriz3;

