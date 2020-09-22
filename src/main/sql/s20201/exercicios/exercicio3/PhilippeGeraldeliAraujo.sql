## Author Philippe Geraldeli Araujo

-- Documentação:

-- cardinality(anyarray),  
--    returns the total number of elements in the array, or 0 if the array is empty 
--    https://www.postgresql.org/docs/9.4/functions-array.html

-- array_length(anyarray, int) 
--    returns the length of the requested array dimension 
--    https://www.postgresql.org/docs/9.4/functions-array.html

-- array_fill(anyelement, int[] [, int[]])
--     returns an array initialized with supplied value and dimensions, optionally with lower bounds other than 1
--     https://www.postgresql.org/docs/9.4/functions-array.html

DROP FUNCTION IF EXISTS multiplicaMatriz(matrizA float[][], matrizB float[][])
DROP FUNCTION IF EXISTS getNumeroLinhasMatriz(matriz float[][])
DROP FUNCTION IF EXISTS getNumeroColunasMatriz(matriz float[][])

CREATE FUNCTION getNumeroLinhasMatriz(matriz float[][]) RETURNS int AS $$
    DECLARE
        numLinhas integer;
    BEGIN
        numLinhas = array_length(matriz, 1);
        RETURN numLinhas;
    END;
$$ LANGUAGE plpgsql

CREATE FUNCTION getNumeroColunasMatriz(matriz float[][]) RETURNS int AS $$
    DECLARE
        numColunas integer;
    BEGIN
        numColunas = cardinality(matriz[1:1]);
        RETURN numColunas;
    END;
$$ LANGUAGE plpgsql


CREATE FUNCTION multiplicaMatriz(matrizA float[][], matrizB float[][]) RETURNS float[][] AS $$

    DECLARE
        matrizResultado float[][];
        qtdLinhasA integer;
        qtdLinhasB integer;
        qtdColunasA integer;
        qtdColunasB integer;
    BEGIN
        qtdLinhasA = getNumeroLinhasMatriz(matrizA);
        qtdColunasA = getNumeroColunasMatriz(matrizA);
        qtdLinhasB = getNumeroLinhasMatriz(matrizB);
        qtdColunasB = getNumeroColunasMatriz(matrizB);

        IF qtdLinhasA = 0 OR qtdLinhasB = 0 OR qtdColunasA = 0 OR qtdColunasB = 0 THEN
            RAISE EXCEPTION 'A matriz informada não é válida'; 
        END IF;
		
        RAISE NOTICE 'qtdColunasA: %', qtdColunasA;
	RAISE NOTICE 'qtdLinhasB: %', qtdLinhasB;
		
        IF qtdColunasA <> qtdLinhasB THEN
            RAISE EXCEPTION 'Para que seja possível calcular o produto entre duas matrizes é necessário que o número de colunas da primeira matriz seja igual ao número de linhas da segunda. Logo a multiplicação informada é inválida';
        END IF;
        
        -- Preenche matriz resultado com a quantidade certa de linhas e colunas
        matrizResultado := array_fill(0,ARRAY[qtdLinhasA,qtdColunasB]);
                 
		
        FOR i IN 1..qtdLinhasA LOOP
            FOR j IN 1..qtdColunasB LOOP
                FOR k IN 1..qtdLinhasB LOOP
                    matrizResultado[i][j] := matrizResultado[i][j] + matrizA[i][k] * matrizB[k][j];
                END LOOP;
            END LOOP;
        END LOOP;

        RETURN matrizResultado;
        
    END;

$$ LANGUAGE plpgsql;

-- Correto, vai fazer a multiplicação.
SELECT multiplicaMatriz('{{1,2}, {3,4}}', '{{5, 7, 9}, {1, 2, 3}}');

-- Vai levantar a exceção
SELECT multiplicaMatriz('{{1, 2}}', '{{1, 1, 1}, {1, 1, 1}, {1, 1, 1}}');