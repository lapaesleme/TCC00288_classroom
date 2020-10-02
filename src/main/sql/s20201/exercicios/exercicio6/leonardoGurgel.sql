create or replace function soma_linhas(matriz float[][], l1 integer, l2 integer, c1 float, c2 float)
returns float[][] as $$
declare
begin
  for i in 1..array_length(matriz, 1) loop
    matriz[l1][i] = c1 * matriz[l1][i] + c2 * matriz[l2][i];
  end loop;
  return matriz;
end;
$$ language plpgsql;

-- esperado: {{2,3,4},{16,19,22},{1,2,3}}
select soma_linhas('{{2,3,4},{7,8,9},{1,2,3}}', 2, 1, 2, 1);