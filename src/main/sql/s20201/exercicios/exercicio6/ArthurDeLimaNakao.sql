DROP TABLE if exists Matriz cascade;

CREATE TABLE Matriz(
    matriz float[][]
);

-- 4x4
INSERT INTO Matriz (matriz)
VALUES ('{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}');

-- 3x3
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');

-- 2x2
-- INSERT INTO Matriz(matriz)
-- VALUES ('{{2, 3}, {4, 5}}');

-- 1x1
-- INSERT INTO Matriz(matriz)
-- VALUES ('{{2}}');


CREATE OR REPLACE FUNCTION operate_line_and_column(A float[][], m integer, n integer, c1 float, c2 float) RETURNS float[][] AS $$
DECLARE
    result float[][];
    line integer;
    col integer;
BEGIN
    line := array_length(A, 1);
    col := array_length(A, 2);

    result := A;

    FOR j IN 1..col LOOP
        result[m][j] := c1 * result[m][j] + c2 * result[n][j];
    END LOOP;

    RETURN result;
END
$$ LANGUAGE plpgsql;

SELECT operate_line_and_column(Matriz.matriz, 1, 2, 2, 2) FROM Matriz;