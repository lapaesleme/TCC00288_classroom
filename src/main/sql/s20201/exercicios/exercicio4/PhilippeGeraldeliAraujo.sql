/**
 * Author:  Philippe Geraldeli
 * Created: 22/09/2020

Escreva uma função PL/pgSQL para excluir uma linha i e uma coluna j de uma matriz m,
onde i, j e m são informados como parâmetros da função.

Dicas:
1. linha = array_append(linha,e) inclui o elemento e no vetor linha
2. m = array_cat(m,array[linha]) inclui o vetor linha na matriz m

 */

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
	
		RAISE NOTICE 'Dimensão Matriz Recebida: %x%', numLinhas, numColunas;

        -- Preenche matriz resultado com a quantidade certa de linhas e colunas
        matrizResultado := array_fill(0, ARRAY[numLinhas - 1, numColunas - 1]);

		
		
        aux1 = 0;

        FOR n IN 1..numLinhas LOOP
			RAISE NOTICE 'n: %', n;
            IF n <> i THEN
				RAISE NOTICE 'n != i';
                aux1 := aux1 + 1;
                aux2 := 1;
                FOR n2 IN 1..numColunas LOOP
                    IF n2 <> j THEN
						RAISE NOTICE 'n2 != j';
                        matrizResultado[aux1][aux2] := matriz[n][n2];
						RAISE NOTICE 'Matriz Resultado: %', matrizResultado;
                        aux2 := aux2 + 1;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;

        RETURN matrizResultado;
            
    END;

$$ LANGUAGE plpgsql;


-- Vão funcionar
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}}', 1, 1);
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}', 1, 1);
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}', 2, 3);
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}', 3, 2);

-- Vão levantar exceção
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}}', 1, 4);
SELECT excluir_linha_coluna('{{1, 2, 3}, {4, 5, 6}}', 4, 1);