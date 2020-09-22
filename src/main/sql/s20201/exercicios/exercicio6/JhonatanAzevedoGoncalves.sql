/*Escreva uma função em PL/pgSQL para operar sobre linhas de uma matriz. Essa função
deverá receber uma matriz �, dois índices de linhas � e � e duas constantes �! e �". O
resultado da função deverá ser a matriz � com a linha � substituída por uma combinação
linear das linhas � e � da seguinte forma: �#$ = �! ∗ �#$ + �" ∗ �%$, para � ∈
[1. . �������(�)]. Define-se essa combinação linear conforme o exemplo a seguir.*/

DROP FUNCTION comb_lin(integer,integer,double precision[],integer,integer);
create or replace function comb_lin(m integer, n integer, a float[][], x integer, y integer) returns float[][] as $$
declare
    resp float[][];
    aux float[];
    e float;
begin
    for i in 1..array_length(a,1)loop

        for j in 1..array_length(a,2) loop
            if i = m then
                e:=x*a[m][j]+y*a[n][j];
            else
                e:=a[i][j];
            end if;
            aux := array_append(aux,e);
        end loop;
        
        resp := array_cat(resp, array[aux]);
	aux:='{}';

    end loop;
    return resp;
end
$$ language plpgsql;


select comb_lin(2,1,'{{1,2,3},{4,5,6},{7,8,9}}'::float[][],3,5);
--resultado = "{{1,2,3},{17,25,33},{7,8,9}}"