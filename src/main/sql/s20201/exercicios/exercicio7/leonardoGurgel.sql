create or replace function transposta(matriz float[][])
returns float[][] as $$
declare
  saida float[][] := '{}';
  vetor_linha float[];
  tam_linha integer := array_length(matriz, 1);
  tam_coluna integer := array_length(matriz, 2);
begin
  
  for coluna in 1..tam_coluna loop
    vetor_linha = '{}';

    for linha in 1..tam_linha loop
      vetor_linha = array_append(vetor_linha, matriz[linha][coluna]);
    end loop;

    saida = array_cat(saida, array[vetor_linha]);
  end loop;

  return saida;
end;
$$ language plpgsql;

-- esperado: {{1,4},{2,5},{3,6}}
select transposta('{{1,2,3},{4,5,6}}');