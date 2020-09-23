
/**
 * Author:  Philippe Geraldeli
 * Created: 22/09/2020
 */

DROP FUNCTION IF EXISTS determinante(matriz float[][]);
DROP FUNCTION IF EXISTS excluir_linha_coluna(matriz float[][], i integer, j integer);

CREATE FUNCTION excluir_linha_coluna(matriz float[][], i integer, j integer) RETURNS float[][] AS $$

    DECLARE
        numLinhas integer;
        numColunas integer;
        aux1 integer;
        aux2 integer;
        matrizResultado float[][];
    BEGIN
        numLinhas = array_length(matriz, 1);
        numColunas = cardinality(matriz[1:1]);
	
		IF i > numLinhas THEN
			RAISE EXCEPTION 'Linha informada inválida';
		END IF;
		
		IF j > numColunas THEN
			RAISE EXCEPTION 'Coluna informada inválida';
		END IF;

        -- Preenche matriz resultado com a quantidade certa de linhas e colunas
        matrizResultado := array_fill(0, ARRAY[numLinhas - 1, numColunas - 1]);

		
		
        aux1 = 0;

        FOR n IN 1..numLinhas LOOP
            IF n <> i THEN
                aux1 := aux1 + 1;
                aux2 := 1;
                FOR n2 IN 1..numColunas LOOP
                    IF n2 <> j THEN
                        matrizResultado[aux1][aux2] := matriz[n][n2];
                        aux2 := aux2 + 1;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;

        RETURN matrizResultado;
            
    END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION determinante(matriz float[][]) RETURNS float AS $$
    DECLARE
        numLinhas integer;
        numColunas integer;
        total float = 0.0;
		aux float;
    BEGIN
        numLinhas = array_length(matriz, 1);
        numColunas = cardinality(matriz[1:1]);

        IF numLinhas <> numColunas THEN
            RAISE EXCEPTION 'A matriz informada não é quadrada';
        END IF;
		IF numColunas = 2 THEN
                        -- detA = a11.a22 – a21.a12
			RETURN (matriz[1][1]*matriz[2][2]) - (matriz[2][1]*matriz[1][2]);
		ELSE 
			FOR j IN 1..numColunas LOOP
				aux := (matriz[1][j]*(-1)^(1+j));
				total := total + aux*determinante((SELECT * FROM excluir_linha_coluna(matriz,1,j)));
			END LOOP;
		END IF;
		
        return total;

    END;
$$ LANGUAGE plpgsql;


SELECT determinante('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');  -- 0
SELECT determinante('{{6, 2, 3}, {4, 4, 6}, {7, 8, 9}}');  -- -48

-- Exceção
SELECT determinante('{{6, 2, 3}, {4, 4, 6}}'); 