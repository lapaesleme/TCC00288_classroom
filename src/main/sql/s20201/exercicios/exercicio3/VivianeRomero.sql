drop table if exists matrizA cascade;

drop table if exists matrizB cascade;

drop table if exists matrizC cascade;


create table matrizA(
    valor float[][]
);

create table matrizB(
    valor float[][]
);

create table matrizC(
    valor float[][]
);
/* preenchimento das tabelas de cada matriz com seus respectivos valores */

/*matriz 2x3*/
INSERT INTO matrizA VALUES (ARRAY[[1,2,3], [4,5,6]]);

/*matriz 3x2*/
INSERT INTO matrizB VALUES (ARRAY[[1,1], [1,1],[1,1]]);

/*matriz 2x2*/
INSERT INTO matrizC VALUES (ARRAY[[2,1], [4,5]]);

CREATE OR REPLACE FUNCTION multiplicarMatrizes(matriz1 float[][], matriz2 float[][]) RETURNS float[][] as $$
DECLARE
    linhasMatriz1 integer;
    colunasMatriz1 integer;
    linhasMatriz2 integer;
    colunasMatriz2 integer;
    matrizResultante float[][];
BEGIN
    SELECT array_length(matriz1, 1) INTO linhasMatriz1;
    SELECT array_length(matriz1, 2) INTO colunasMatriz1;
    SELECT array_length(matriz2, 1) INTO linhasMatriz2;
    SELECT array_length(matriz2, 2)INTO colunasMatriz2;
    SELECT array_fill(0, ARRAY[linhasMatriz1, colunasMatriz2]) INTO matrizResultante;
/* se a qtd de linhas da matriz 2 nao for igual a qtd de colunas da matriz 1, ele dispara essa excecao*/
    IF colunasMatriz1 <> linhasMatriz2 THEN
        RAISE EXCEPTION 'Matrizes incompativeis para operacao de mutiplicacao';
    ELSE
        FOR i IN 1..linhasMatriz1 LOOP
            FOR j IN 1..colunasMatriz2 LOOP
                FOR k IN 1..colunasMatriz1 LOOP
                    matrizResultante[i][j] := matrizResultante[i][j] + matriz1[i][k] * matriz2[k][j];
                END LOOP;
            END LOOP;
        END LOOP;
    END IF;
    RETURN matrizResultante;
END;
$$ LANGUAGE plpgsql;

/*vai multiplicar as matrizes A e B pois sao compativeis*/
SELECT multiplicarMatrizes(matrizA.valor, matrizB.valor) FROM matrizA, matrizB;

/*nao vai multiplicar as matrizes A e C pois sao incompativeis*/
SELECT multiplicarMatrizes(matrizA.valor, matrizC.valor) FROM matrizA, matrizC;

/*vai multiplicar as matrizes B e A pois sao compativeis*/
SELECT multiplicarMatrizes(matrizB.valor, matrizA.valor) FROM matrizA, matrizB;

/*vai multiplicar as matrizes B e C pois sao compativeis*/
SELECT multiplicarMatrizes(matrizB.valor, matrizC.valor) FROM matrizC, matrizB;

/*vai multiplicar as matrizes C e A pois sao compativeis*/
SELECT multiplicarMatrizes(matrizC.valor, matrizA.valor) FROM matrizA, matrizC;

/*nao vai multiplicar as matrizes C e B pois sao incompativeis*/
SELECT multiplicarMatrizes(matrizC.valor, matrizB.valor) FROM matrizB, matrizC;