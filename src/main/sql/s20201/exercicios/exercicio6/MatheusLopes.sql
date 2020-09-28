/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  matheus
 * Created: 21/09/2020
 */

drop table if exists matriz cascade;

create table matriz (
    val float[][]
);

insert into matriz values (array[[1,2,3],[4,5,6],[7,8,9]]);

create or replace function operaLinhaDaMat (mat float[][], m integer, n integer, c1 integer, c2 integer)
returns float[][] as $$
    declare
        mat_j integer;
   
    begin
        select array_length(mat, 1) into mat_j;

        for j in 1..mat_j loop
            mat[m][j] = c1*mat[m][j] + c2*mat[n][j];
        end loop;
        return mat;
    end;
$$
language plpgsql;


select operaLinhaDaMat (matriz.val, 2, 2, 3, 4) from matriz;