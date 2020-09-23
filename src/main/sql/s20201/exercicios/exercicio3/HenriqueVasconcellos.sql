DROP TABLE if exists matriz;
DROP TABLE if exists matriz2;
DROP TABLE if exists matriz3;

CREATE TABLE matriz(
    valores float[][]
);
INSERT INTO matriz (valores) VALUES (ARRAY [[1, 1, 1],[2, 2, 2],[3, 3, 3]]);

CREATE TABLE matriz2(
    valores float[][]
);
INSERT INTO matriz2 (valores) VALUES (ARRAY [[2, 2, 2],[2, 2, 2],[2, 2, 2]]);

CREATE TABLE matriz3(
    valores float[][]
);
INSERT INTO matriz3 (valores) VALUES (ARRAY [[1],[1],[1]]);

DROP FUNCTION if exists multiplicaMatriz;
CREATE OR REPLACE FUNCTION multiplicaMatriz(m1 float[][], m2 float[][]) RETURNS float[][] AS $$
DECLARE
    m1Colunas integer;
    m2Colunas integer;
    m1Linhas integer;
    m2Linhas integer;
    m3 float[][];
BEGIN
    m1Colunas = array_length(m1,1);
    m2Colunas = array_length(m2,1);
    m1Linhas = array_length(m1,2);
    m2Linhas = array_length(m2,2);
    m3 := array_fill(0, ARRAY[m1Linhas,m2Colunas]);

    IF m1Colunas != m2Linhas THEN
        RAISE EXCEPTION 'Matrizes incompativeis';
    END IF;

    FOR v IN 1..m1Colunas LOOP
        FOR i IN 1..m2Linhas LOOP
            FOR j IN 1..m2Colunas LOOP
                m3[v][i] = m3[v][i] + m1[v][j]*m2[j][i];
            END LOOP;
        END LOOP;
    END LOOP;
    RETURN m3;
END;
$$ LANGUAGE plpgsql;

SELECT multiplicaMatriz(matriz.valores,matriz2.valores) FROM matriz,matriz2;
SELECT multiplicaMatriz(matriz.valores,matriz3.valores) FROM matriz,matriz3;

