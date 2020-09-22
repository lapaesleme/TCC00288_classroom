drop table if exists matrix1;

drop table if exists matrix2;

drop table if exists matrix3;

drop table if exists matrix4;

drop function if exists multMatrix() cascade;

CREATE TABLE matrix1 (
    matriz float[][]
);

CREATE TABLE matrix2 (
    matriz float[][]
);

CREATE TABLE matrix3 (
    matriz float[][]
);

CREATE TABLE matrix4 (
    matriz float[][]
);

INSERT INTO matrix1 (matriz)
    VALUES ('{{2,4},{3,0}}');

INSERT INTO matrix2 (matriz)
    VALUES ('{{2,2,4},{1,2,0}}');

INSERT INTO matrix3 (matriz)
    VALUES ('{{2,4},{3,0}}');

INSERT INTO matrix4 (matriz)
    VALUES ('{{2,2,4},{1,2,0},{1,1,2}}');

CREATE or REPLACE FUNCTION multMatrix (matrix1 float[][], matrix2 float[][]) RETURNS float[][] AS $$
DECLARE
    multResult float[][];
    parcResult float;
    m1_l integer;
    m2_c integer;
BEGIN
    
  m1_l := array_length(matrix1,1);
  m2_c := array_length(matrix2,2);

  multResult := array_fill(0, ARRAY[m1_l, m2_c]);

  IF array_length(matrix1,2) <> array_length(matrix2,1) THEN
    RAISE EXCEPTION 'Matrizes incompatíveis';
  END IF;

  FOR linha IN 1..array_length(matrix1,1) LOOP
    FOR coluna IN 1..array_length(matrix2, 2) LOOP
        
        FOR numero IN 1..array_length(matrix1,2) LOOP
            multResult[linha][coluna] := multResult[linha][coluna] + (matrix1[linha][numero] * matrix2[numero][coluna]);
        END LOOP;

    END LOOP;
  END LOOP;

  RETURN multResult;
END;
$$ LANGUAGE plpgsql;


SELECT multMatrix(matrix1.matriz, matrix2.matriz) FROM matrix1, matrix2; /* Sem problemas */
SELECT multMatrix(matrix3.matriz, matrix4.matriz) FROM matrix3, matrix4; /* Lança exceção */