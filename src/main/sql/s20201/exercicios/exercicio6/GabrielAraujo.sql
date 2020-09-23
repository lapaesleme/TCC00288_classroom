CREATE OR REPLACE FUNCTION combL (A float[][], m integer, n integer, c1 float, c2 float) RETURNS FLOAt[][] as $$
DECLARE
	linhas integer;
	colunas integer;
	aux float[];
	
BEGIN

	linhas := ARRAY_LENGTH(A,1);
	colunas := ARRAY_LENGTH(A,2);
	
  for j in 1..colunas loop
    A[m][j] = A[m][j]*c1 + A[n][j]*c2;
  end loop;

  return A;
END;
$$ LANGUAGE plpgsql;

select combL('{{1,2,3},{1,2,3},{1,2,3}}'::float[][], 3,1,2,1);

