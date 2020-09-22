DROP TABLE if exists Matriz cascade;

CREATE TABLE Matriz(
    matriz float[][]
);

-- 3x3
INSERT INTO Matriz (matriz)
VALUES ('{{1, 2, 3}, {5, 35, 22}, {12, 8, 9}}');

-- 2x2
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{2, 3}, {4, 5}}');

-- 1x1
-- INSERT INTO Matriz (matriz)
-- VALUES ('{{20}}');

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

CREATE OR REPLACE FUNCTION determinante(matriz float[][]) RETURNS float AS $$
DECLARE
    det integer;
    aux integer;
    i integer;
BEGIN
    i := 1;
    det := 0;
    
    IF array_length(matriz, 1) > 0 THEN
        FOR j IN 1..array_length(matriz, 2) LOOP
            det := det + matriz[i][j] * ((-1) ^ (i+j)) * determinante(remove_line_column(i, j, matriz));
        END LOOP;
    ELSE
        det := 1;
    END IF;
    
    RETURN det;
END
$$ LANGUAGE plpgsql;

SELECT determinante(Matriz.matriz) FROM Matriz;