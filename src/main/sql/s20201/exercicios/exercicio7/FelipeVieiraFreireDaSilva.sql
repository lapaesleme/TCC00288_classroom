CREATE OR REPLACE FUNCTION transpor (mat float[][])
    RETURNS float[][]
    AS $$
    DECLARE
        qtdLin integer;
        qtdCol integer;
        transposta float[][];
    BEGIN
        SELECT array_length(mat, 1) INTO qtdLin;
        SELECT array_length(mat, 2) INTO qtdCol;
        SELECT array_fill(0,ARRAY[qtdCol,qtdLin]) INTO transposta;
        FOR i IN 1.. qtdCol LOOP
                FOR j IN 1..qtdLin LOOP
                    transposta[i][j] = mat[j][i];
                END LOOP;
        END LOOP;
        RETURN transposta;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT transpor(ARRAY[[1,2],[3,4],[5,6]]) FROM matrix;