/* Escreva uma função e, PL/pgSQL para multiplicar duas matrizes. Caso as matrizes sejam
incompatíveis a função deverá disparar uma exceção. A função deve receber como
parâmetros duas matrizes do tipo float[][] e retornar outra matriz do tipo float[][].

Dicas:
a) use FOR v IN 1..n LOOP
b) valem as mesmas dicas da questão anterior */


CREATE OR REPLACE FUNCTION multiplica_matriz(m1 float[][], m2 float[][]) RETURNS float[][] AS $$
DECLARE
resp float[][];
sum INTEGER := 0;
l integer;
l1 integer;
c integer;
r integer;

BEGIN
	l:= ARRAY_LENGTH(m1,1);
	r:= ARRAY_LENGTH(m1,2);
	l1:= ARRAY_LENGTH(m2,1);
	c:= ARRAY_LENGTH(m2,2);

	if r<>l1 THEN
		RAISE EXCEPTION 'Tamanhos incompativeis';
	end if;

	resp := array_fill(0, array[l,c]);

	FOR k in 1..l LOOP
		FOR i in 1..c LOOP
		    FOR j in  1..r LOOP 
			sum := sum + m1[k][j]*m2[j][i];
		    END LOOP;
		    resp[k][i] := sum;
		    sum := 0;
		END LOOP;
	END LOOP;

	return resp;

END
$$LANGUAGE plpgsql;


select multiplica_matriz('{{1,2,3},{2,3,4}}'::float[][], '{{1,2,3,4},{3,4,5,6}}'::float[][]);
--tipos incompativeis


select multiplica_matriz('{{1,2},{2,3}}'::float[][], '{{1,2,3,4},{3,4,5,6}}'::float[][]);
--resultado = {{7,10,13,16},{11,16,21,26}}
