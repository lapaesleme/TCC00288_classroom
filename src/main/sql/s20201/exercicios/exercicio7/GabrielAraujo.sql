CREATE OR REPLACE FUNCTION transpM (A float[][]) RETURNS FLOAt[][] as $$
DECLARE
	linhas integer;
	colunas integer;
	aux float[];
  	r float[][];
BEGIN

	linhas := ARRAY_LENGTH(A,1);
	colunas := ARRAY_LENGTH(A,2);

  r := array_fill(0, array[colunas,linhas]);

  for i in 1..linhas loop
    for j in 1..colunas loop
      r[j][i] = A[i][j];
    end loop;
  end loop;


  return r;
END;
$$ LANGUAGE plpgsql;


select transpM('{{1,2,3},{4,5,6}}'::float[][]);

