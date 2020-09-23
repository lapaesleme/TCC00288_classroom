DROP TABLE IF EXISTS matrix;
CREATE TABLE matrix
(
    valores float[][]
);
INSERT INTO matrix(valores) VALUES(ARRAY[    [1, 1, 1, 1],
                                            [1, 1, 1, 1],
                                            [1, 1, 1, 1],
                                            [1, 1, 1, 1]]
);


CREATE OR REPLACE FUNCTION combinar (mat float[][], linha1 int, linha2 int, const1 int, const2 int)
    RETURNS float[][]
    AS $$
    DECLARE
        qtdLinInicial integer;
        qtdColInicial integer;
    BEGIN
        SELECT array_length(mat, 1) INTO qtdLinInicial;
        SELECT array_length(mat, 2) INTO qtdColInicial;
        FOR i IN 1..qtdLinInicial LOOP
            IF i = linha1 THEN
                FOR j IN 1..qtdColInicial LOOP
                    mat[linha1][j] = const1 * mat[linha1][j] + const2 * mat[linha2][j];
                END LOOP;   
            END IF;
        END LOOP;
        RETURN mat;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT combinar(matrix.valores, 1, 2, 2, 2) FROM matrix;