
CREATE OR REPLACE FUNCTION exclui_linha_coluna(matriz FLOAT[][], linha INTEGER, coluna INTEGER)
RETURNS FLOAT[][] AS $$
DECLARE
  saida FLOAT[][];
  vetor_linha FLOAT[];
BEGIN
  FOR l IN 1..array_length(matriz, 1) LOOP
    IF l <> linha THEN
      
      vetor_linha = '{}';
      FOR c IN 1..array_length(matriz, 2) LOOP
        IF c <> coluna THEN
          vetor_linha = array_append(vetor_linha, matriz[l][c]);
        END IF;
      END LOOP;

      saida = array_cat(saida, ARRAY[vetor_linha]);
    END IF;
  END LOOP;

  RETURN saida;
END;
$$ language plpgsql;

-- esperado: {{1,3},{7,9}}
SELECT exclui_linha_coluna('{{1,2,3},{4,5,6},{7,8,9}}'::FLOAT[][], 2, 2);