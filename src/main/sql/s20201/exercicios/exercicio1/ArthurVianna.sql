/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  Arthur
 * Created: 14 de set. de 2020
 */

drop table if exists pessoa  cascade;
drop table if exists pessoa2  cascade;

create table pessoa(
nome varchar,
endereco varchar
);

create table pessoa2(
nome varchar,
endereco varchar
);

insert into pessoa values ('Luiz Andre','end');
insert into pessoa values ('Luiz','end2');

select * from pessoa;
