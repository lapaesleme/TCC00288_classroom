/*Implemente uma função em PL/pgSQL para transpor uma matriz. A função deve receber
uma matriz do tipo float[][] e retornar outra matriz do tipo float[][].

Dicas:
1. a expressão linha = array_append(linha,e) inclui o elemento e no vetor
linha
2. a expressão m = array_cat(m,array[linha]) inclui o vetor linha em na
matriz m*/

create or replace function transpor(m float[][]) returns float[][] as $$
declare
	resp float[][];
	aux float[];
begin
	for i in 1..array_length(m, 1)loop
		for j in 1..array_length(m,2)loop
			aux:= array_append(aux,m[j][i]);
		end loop;
		resp:= array_cat(resp, array[aux]);
		aux:='{}';
	end loop;
	return resp;
end
$$language plpgsql;

select transpor('{{1,2,3},{4,5,6},{7,8,9}}'::float[][]);
-- resultado="{{1,4,7},{2,5,8},{3,6,9}}"