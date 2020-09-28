DROP TABLE IF EXISTS matrix;
CREATE TABLE matrix
(
    valores float[][]
);
INSERT INTO matrix(valores) VALUES(ARRAY[    [3, 1, 0, 1],
                                            [0, -1, 3, 4],
                                            [1, 1, 0, 2],
                                            [0, 1, 1, -1]]
);

CREATE OR REPLACE FUNCTION excluir (mat float[][], linha int, coluna int)
    RETURNS float[][]
    AS $$
    DECLARE
        qtdLinInicial integer;
        qtdColInicial integer;
        qtdLinFinal integer;
        qtdColFinal integer;
        matAux float[];
        matVazia float[];
        matFinal float[][];
        
    BEGIN
        SELECT array_length(mat, 1) INTO qtdLinInicial;
        SELECT array_length(mat, 2) INTO qtdColInicial;
        SELECT array_length(mat, 1) - 1 INTO qtdLinFinal;
        SELECT array_length(mat, 2) - 1 INTO qtdColFinal;
        IF qtdLinFinal = 0 OR qtdColFinal = 0 THEN
            RAISE EXCEPTION 'Nao e possivel fazer remocao; matriz deixaria de existir.';
        END IF;
        FOR i IN 1..qtdLinInicial LOOP
            IF i != linha THEN
                FOR j IN 1..qtdColInicial LOOP
                    IF j != coluna THEN
                        matAux := array_append(matAux, mat[i][j]);
                    END IF;
                END LOOP;
                matFinal := array_cat(matFinal, ARRAY[matAux]);
                matAux := matVazia;      
            END IF;
        END LOOP;
        RETURN matFinal;
    END;
$$
    LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION determinante (mat float[][])
    RETURNS float
    AS $$
    DECLARE

        qtdLin integer;
        qtdCol integer;
        linhaPivot integer := 2;
        resultado integer := 0;

    BEGIN
        SELECT array_length(mat, 1) INTO qtdLin;
        SELECT array_length(mat, 2) INTO qtdCol;
        IF qtdLin = 2 AND qtdCol = 2 THEN
            RETURN mat[1][1] * mat[2][2] - (mat[1][2] * mat[2][1]);
        END IF;
        FOR i IN 1..qtdCol LOOP

            resultado := resultado + mat[linhaPivot][i] * (-1)^(i + linhaPivot) * determinante(excluir(mat, linhaPivot, i));

        END LOOP;
        RETURN resultado;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT determinante(matrix.valores) FROM matrix;