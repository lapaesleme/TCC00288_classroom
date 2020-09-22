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

CREATE OR REPLACE FUNCTION determinante (m float[][]) RETURNS float as $$
DECLARE
	r float;
	aux float[];
	
BEGIN
	r := 0;
	if ARRAY_lENGTH(M,1) = 1 THEN
		RETURN M[1][1];
	END IF;
	for j in 1..ARRAY_LENGTH(M,1) loop
		r := r + m[1][j]*power(-1,j+1)*determinante(removeLeC(m,1,j));
	end loop;
	return r;
END;
$$ LANGUAGE plpgsql;

select determinante('{{1,2,3},{4,5,6},{7,8,9}}'::float[][]);
