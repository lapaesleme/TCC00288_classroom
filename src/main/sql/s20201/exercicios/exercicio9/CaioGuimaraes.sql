/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 23 de set. de 2020
 */

drop table if exists pais cascade;
drop table if exists estado cascade;

drop function if exists computarAreaMediana(varchar) cascade;

create table pais(
    codigo int,
    nome varchar
);

create table estado(
    nome varchar,
    pais varchar,
    area float
);

insert into pais values (55, 'Brasil');
insert into pais values (1, 'Brasil');

insert into estado values ('Rio de Janeiro', 'Brasil', 43696);
insert into estado values ('Sao Paulo', 'Brasil', 248209);
insert into estado values ('Bahia', 'Brasil', 567295);
insert into estado values ('Acre', 'Brasil', 152581);

insert into estado values ('California', 'Estados Unidos', 423970);
insert into estado values ('Florida', 'Estados Unidos', 170304);
insert into estado values ('Nova York', 'Estados Unidos', 141300);

/*select * from pais;
select * from estado;*/

create function computarAreaMediana(varchar) returns float as $$
declare
    p alias for $1;
    mediana float;
    areas float[];
    aux float;
    tam int;
    pos int;
    pos2 int;
begin
    for aux in select area from estado where estado.pais = p order by area loop
        /*raise notice 'area: %', aux;*/
        areas := array_append(areas, aux);
        /*raise notice 'vetor: %', areas;*/
    end loop;

    select array_length(areas, 1) into tam;

    if tam is NULL then
        return 0;
    end if;

    if tam%2 !=0 then
        pos := tam/2 + 1;
        raise notice 'mediana: %', areas[pos];
        return areas[pos];
    else
        pos := tam/2;
        pos2 := tam/2 + 1;
        mediana := (areas[pos] + areas[pos2])/2;
        raise notice 'mediana: %', mediana;
        return mediana;
    end if;

end
$$
language plpgsql;

select computarAreaMediana('Brasil');
select computarAreaMediana('Estados Unidos');
select computarAreaMediana('China');