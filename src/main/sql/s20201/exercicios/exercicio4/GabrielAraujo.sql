CREATE OR REPLACE FUNCTION multMatriz (m float[][], i, j) RETURNS FLOAt[][] as $$
DECLARE
	r FLOAT[][];
	linhas integer;
	colunas integer;
	aux float[];
	
BEGIN

	linhas := ARRAY_LENGTH(m,1);
	colunas := ARRAY_LENGTH(m,2);
	
	FOR x in 1..linhas loop
		for y in 1..colunas loop
			if(i=x or j=y) THEN
				aux := ARRAY_APPEND(AUX,m[x][y]);
			end if;
		end loop;
		r := ARRAY_CAT(r,aux);
	END Loop;
	return r;
END;
$$ LANGUAGE plpgsql;

select multMatriz('{{1,2,3},{1,2,3},{1,2,3}}'::float[][], 1,1);
--{{22,28,45},{22,28,45},{22,28,45}}
