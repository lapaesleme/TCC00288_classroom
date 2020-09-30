create or replace function exclui_linha_coluna(matriz float[][], linha integer, coluna integer)
returns float[][] as $$
declare
  saida float[][];
  vetor_linha float[];
begin
  for l in 1..array_length(matriz, 1) loop
    if l <> linha then
      
      vetor_linha = '{}';
      FOR c in 1..array_length(matriz, 2) loop
        if c <> coluna then
          vetor_linha = array_append(vetor_linha, matriz[l][c]);
        end if;
      end loop;

      saida = array_cat(saida, array[vetor_linha]);
    end if;
  end loop;

  return saida;
end;
$$ language plpgsql;

create or replace function determinante(matriz float[][])
returns float as $$
declare
  tam_linha integer := array_length(matriz, 1);
  tam_coluna integer := array_length(matriz, 2);
  acc float := 0;
begin
  if tam_linha <> tam_coluna then
    raise exception 'só é possível calcular determinantes de matrizes quadradas';
  end if;

  if tam_linha = 1 then
    return matriz[1][1];
  end if;

  for i in 1..tam_linha loop
    acc = acc + matriz[i][1] * power(-1, i) * determinante(exclui_linha_coluna(matriz, i, 1));
  end loop;

  return acc;
end;
$$ language plpgsql;

-- esperado: 0
select determinante('{{2,2},{2,2}}');

-- esperado: 8424
select determinante('{{1,-8,50},{12,-4,20},{0,15,-3}}');

-- esperado: erro
select determinante('{{1,-8,50},{12,-4,20}}');