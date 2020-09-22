create or replace function multiplica_matrizes(a float[][], b float[][])
returns float[][] as $$
declare
  saida float[][];
  num_linhas_a integer;
  num_colunas_b integer;
  num_colunas_a integer;
begin
  num_linhas_a := array_length(a, 1);
  num_colunas_b := array_length(b, 2);
  num_colunas_a := array_length(a, 2);

  if num_colunas_a <> array_length(b, 1) then
    raise exception 'multiplicação impossível';
  end if;

  saida := array_fill(0, array[num_linhas_a,num_colunas_b]);

  for linha in 1..num_linhas_a loop
    for coluna in 1..num_colunas_b loop
      for i in 1..num_colunas_a loop
        saida[linha][coluna] := saida[linha][coluna] + a[linha][i] * b[i][coluna];
      end loop;
    end loop;
  end loop;

  return saida;
end;
$$ language plpgsql;

-- esperado: {{22, 28}, {22, 28}}
select multiplica_matrizes('{{1,2,3},{1,2,3}}'::float[][], '{{1,2},{3,4},{5,6}}'::float[][]); 

-- esperado: {{8, 8}, {8, 8}}
select multiplica_matrizes('{{2,2},{2,2}}'::float[][], '{{2,2},{2,2}}'::float[][]);