CREATE OR REPLACE FUNCTION multMatriz (m1 float[][], m2 float[][]) RETURNS FLOAt[][] as $$
DECLARE
    r FLOAT[][];
	linhas integer;
	colunas integer;
	aux integer;
	
BEGIN

	linhas := ARRAY_LENGTH(m1,1);
	colunas := ARRAY_LENGTH(m2,2);
	aux := ARRAY_LENGTH(m1,2);
	
	r := array_fill(0, array[linhas,colunas]);
	
	if ARRAY_LENGTH(m1,2)<>ARRAY_LENGTH(m2,1) THEN
		RAISE exception 'Tamanhos incompativeis!!!';
	end if;
	
    FOR i in 1..linhas loop
		for j in 1..colunas loop
			FOR k in 1..aux loop
				r[i][j] := r[i][j] + m1[i][k] * m2[k][j];
			END LOOP;
		end loop;
    END Loop;
    return r;
END;
$$ LANGUAGE plpgsql;

select multMatriz('{{1,2,3}}'::float[][], '{{1,2},{3,4}}'::float[][]);
--erro
select multMatriz('{{1,3,2},{1,4,3}}'::float[][], '{{1,3},{2,2},{2,1}}'::float[][]);
--{{11,11},{15,14}}
select multMatriz('{{1,2,3},{1,2,3},{1,2,3}}'::float[][], '{{1,2,7},{3,4,7},{5,6,8}}'::float[][]);
--{{22,28,45},{22,28,45},{22,28,45}}
select multMatriz('{{1,2},{2,3}}'::float[][], '{{1,2,3,4},{3,4,5,6}}'::float[][]);
--{{7,10,13,16},{11,16,21,26}}
