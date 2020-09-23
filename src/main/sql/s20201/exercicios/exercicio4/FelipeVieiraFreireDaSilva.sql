DROP TABLE IF EXISTS matriz;
DROP TABLE IF EXISTS matrizUni;

CREATE TABLE matriz
(
    valores float[][]
);

CREATE TABLE matrizUni
(
    valores float[][]
);


INSERT INTO matriz (valores) VALUES (ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9]]);

INSERT INTO matrizUni (valores) VALUES (ARRAY[[1,2]]); 


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

--DÁ CERTO SELECT excluir(matriz.valores, 1, 2) FROM matriz

--DÁ ERRADO SELECT excluir(matrizUni.valores, 1, 2) FROM matrizUni