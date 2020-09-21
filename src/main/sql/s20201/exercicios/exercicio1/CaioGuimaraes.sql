/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 20 de set. de 2020
 */

drop table if exists pessoa  cascade;
create table pessoa(
    nome varchar,
    endereco varchar
);

insert into pessoa values ('Caio Guimaraes','endereco');
insert into pessoa values ('Caio','end2');

select * from pessoa;