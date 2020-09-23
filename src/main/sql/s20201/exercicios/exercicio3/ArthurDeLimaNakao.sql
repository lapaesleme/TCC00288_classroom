DROP TABLE if exists Matriz cascade;
DROP TABLE if exists Matriz2 cascade;

CREATE TABLE Matriz(
    matriz float[][]
);

CREATE TABLE Matriz2(
    matriz float[][]
);

-- 3x3
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');
-- 
-- INSERT INTO Matriz2 (matriz)
-- VALUES ('{{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}');

-- 2x2
INSERT INTO Matriz (matriz)
VALUES ('{{2, 3}, {4, 5 }}');

INSERT INTO Matriz2 (matriz)
VALUES ('{{4, 3}, {2, 3}}');

CREATE OR REPLACE FUNCTION mult(m float[][], n float[][]) RETURNS float[][] AS $$
DECLARE
    mult float[][];
BEGIN
    mult := array_fill(0, ARRAY[array_length(m, 1), array_length(n, 2)]);
    FOR i IN 1..array_length(m, 1) LOOP
        FOR j IN 1..array_length(m, 2) LOOP
            FOR k IN 1..array_length(m, 1) LOOP
                mult[i][j] := mult[i][j] + (m[i][k] * n[k][j]);
            END LOOP;
        END LOOP;
    END LOOP;
    RETURN mult;
END
$$ LANGUAGE plpgsql;

SELECT mult(Matriz.matriz, Matriz2.matriz) FROM Matriz, Matriz2;