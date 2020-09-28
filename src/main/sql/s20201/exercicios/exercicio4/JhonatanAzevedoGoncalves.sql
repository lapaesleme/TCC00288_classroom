/*Escreva uma função PL/pgSQL para excluir uma linha i e uma coluna j de uma matriz m,
onde i, j e m são informados como parâmetros da função.

Dicas:
1. linha = array_append(linha,e) inclui o elemento e no vetor linha
2. m = array_cat(m,array[linha]) inclui o vetor linha na matriz m*/

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

select retira_l_c(2, 3, '{{1,2,3},{2,3,4}}'::float[][]);
--resultado = {1,2}