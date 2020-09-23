drop function if exists excij(i integer, j integer, matrix float[][]) cascade;

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
    
    auxArray = '{}'; /*testar*/

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

select excij(1,3,'{{3,4,5},{6,7,8},{9,0,0}}');