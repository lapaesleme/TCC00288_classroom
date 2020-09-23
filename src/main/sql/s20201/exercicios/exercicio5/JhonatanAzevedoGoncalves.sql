/*O determinante de uma matriz quadrada �!×! pode ser calculado pela regra de Laplace
segundo a fórmula a seguir.

|�| = $�#$
!
$%&
(−1)#'$|�#$|

onde �#$ é a submatriz de � retirando-se a i-ésima linha e a j-ésima coluna. A soma é calculada
para uma linha i qualquer da matriz �. Considerando uma função já escrita para o cálculo de
�#$, escreva uma função em PL/pgSQL para calcular o determinante de uma matriz quadrada
�. A função determinante() deve ser recursiva.*/

create or replace function retira_l_c(i integer, j integer, m float[][]) returns float[][] as $$
declare
	resp float[][];
	aux float[];
begin
	for k in 1..array_length(m,1)loop
		for w in 1..array_length(m,2)loop
			if j<>w then
				aux := array_append(aux,m[k][w]);
			end if;
		end loop;
		if i<>k then
			resp := array_cat(resp, array[aux]);
		end if;
		aux := '{}';
	end loop;	
	return resp;
end
$$ language plpgsql; 

create or replace function determinante(m float[][]) returns float as $$
declare
	sum float :=0;
	tam integer :=0;
begin
	tam := array_length(m,2);

	if tam = 1 then
		return m[1][1];
	end if;

	for i in 1..tam loop

		sum := sum + m[1][i]*power(-1,1+i)*determinante(retira_l_c(1,i,m));
	end loop;

	return sum;
end
$$ language plpgsql; 

select determinante('{{1,2,3},{4,5,6},{7,8,9}}'::float[][]);
--resultado = 0