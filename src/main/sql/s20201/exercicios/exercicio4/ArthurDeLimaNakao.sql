DROP TABLE if exists Matriz cascade;

CREATE TABLE Matriz(
    matriz float[][]
);

-- 4x4
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}');

-- 3x3
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');

-- 2x2
INSERT INTO Matriz(matriz)
VALUES ('{{2, 3}, {4, 5}}');

-- 1x1
-- INSERT INTO Matriz(matriz)
-- VALUES ('{{2}}');


CREATE OR REPLACE FUNCTION remove_line_column(i integer, j integer, m float[][]) RETURNS float[][] AS $$
DECLARE
    result float[][];
    line integer;
    col integer;
    aux float[];
BEGIN
    line := array_length(m, 1);
    col := array_length(m, 2);

    result := array_fill(0, ARRAY[0, 0]);

    FOR var1 IN 1..line LOOP
        aux := '{}';
        FOR var2 IN 1..col LOOP
            IF var1 <> i and var2 <> j THEN
                aux := array_append(aux, m[var1][var2]);
            END IF;
        END LOOP;
        result := array_cat(result, ARRAY[aux]);
    END LOOP;

    RETURN result;
END
$$ LANGUAGE plpgsql;

SELECT remove_line_column(1, 1, Matriz.matriz) FROM Matriz;