CREATE OR REPLACE FUNCTION removeLeC (m float[][], i integer, j integer) RETURNS FLOAt[][] as $$
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
			if(i<>x and j<>y) THEN
				aux := ARRAY_APPEND(AUX,m[x][y]);
			end if;
		end loop;
		r := r || Array[aux];
		aux := '{}';
	END Loop;
	return r;
END;
$$ LANGUAGE plpgsql;

select removeLeC('{{1,2,3},{1,2,3},{1,2,3}}'::float[][], 2,2);
--{{1,3},{1,3}}
