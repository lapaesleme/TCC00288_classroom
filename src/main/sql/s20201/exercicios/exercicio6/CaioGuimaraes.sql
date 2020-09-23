/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 22 de set. de 2020
 */

drop table if exists matriz1 cascade;

drop function if exists combinacaoLinear(matriz float[][], m int, n int, c1 int, c2 int) cascade;

create table matriz1(
    valores float[][]
);

insert into matriz1 values ('{{4,2,3},{1,5,2},{7,2,4}}');

/*select * from matriz;*/

create function combinacaoLinear(matriz float[][], m int, n int, c1 int, c2 int) returns float[][] as $$
    declare
        qtdLinhas int;
        qtdColunas int;
        amj float;
        novaLinha float[];
        resultado float[][];
    begin
        select array_length(matriz, 1) into qtdLinhas;
        select array_length(matriz, 2) into qtdColunas;

        if m < 1 or m > qtdLinhas then
            raise exception 'Fator m inválido!';
        end if;

        if n < 1 or n > qtdLinhas then
            raise exception 'Fator n inválido!';
        end if;

        select array_fill(0, array[qtdLinhas, qtdColunas]) into resultado;

        for j in 1..qtdColunas loop
            amj := c1*matriz[m][j] + c2*matriz[n][j];
            novaLinha = array_append(novaLinha, amj);
            /*raise notice 'amj: %', amj;*/
        end loop;

        for i in 1..qtdLinhas loop
            for j in 1..qtdColunas loop
                if i = m then
                    matriz[i][j] := novaLinha[j];
                end if;
            end loop;
        end loop;

        return matriz;
    end
$$
language plpgsql;

select combinacaoLinear(matriz1.valores, 1, 2, 3, 3) from matriz1;

