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


CREATE OR REPLACE FUNCTION transposed_matrix(matrix float[][]) RETURNS float[][] AS $$
DECLARE
    result float[][];
    line integer;
    col integer;
    aux_line float[];
BEGIN
    line := array_length(matrix, 1);
    col := array_length(matrix, 2);

    result := array_fill(0, ARRAY[col, line]);

    FOR i IN 1..line LOOP
        FOR j IN 1..col LOOP
            result[j][i] := matrix[i][j];
        END LOOP;
    END LOOP;

    RETURN result;
END
$$ LANGUAGE plpgsql;

SELECT transposed_matrix(Matriz.matriz) FROM Matriz;