drop function if exists excij(i integer, j integer, matrix float[][]) cascade;
drop function if exists determinante(matrix float[][]) cascade;

CREATE or REPLACE FUNCTION excij(i integer, j integer, matrix float[][]) RETURNS float[][] AS $$
DECLARE
    resultMatrix float[][];
    m_l integer;
    m_c integer;
    auxArray float[];
BEGIN

  m_l := array_length(matrix,1);
  m_c := array_length(matrix,2);

  FOR linha IN 1..m_l LOOP
    
    auxArray = '{}';

    FOR coluna IN 1..m_c LOOP
        IF linha <> i AND coluna <> j THEN
            auxArray = array_append(auxArray, matrix[linha][coluna]);
        END IF;
    END LOOP;

    resultMatrix = array_cat(resultMatrix, array[auxArray]);

  END LOOP;

  RETURN resultMatrix;
END;
$$ LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION determinante(matrix float[][]) RETURNS float AS $$
DECLARE
    resultDet float := 0;
    i integer := 1;
BEGIN

   IF array_length(matrix, 2) = 1 THEN /*Condicao de parada a matrix eh um unico numero*/
        RETURN matrix[1][1]; 
   END IF;


   FOR j IN 1..array_length(matrix, 2) LOOP
    resultDet = resultDet + (matrix[i][j] * (-1)^(i+j) * determinante(excij(i,j,matrix)));
   END LOOP;
    
  RETURN resultDet;
END;
$$ LANGUAGE plpgsql;


select determinante('{{3,4,4,2},{5,5,5,2},{6,4,1,13},{7,6,5,4}}');