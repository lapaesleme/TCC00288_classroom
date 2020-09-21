/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  victor
 * Created: 14 de set. de 2020
 */

drop table if exists pessoa cascade;

create table pessoa(
nome varchar,
endereco varchar,
cpf varchar
);

insert into pessoa values ('Victor Guarana','Rua 1 casa 1', '00000000000');
insert into pessoa values ('Zé','Rua 1 casa 2', '11111111111');

select * from pessoa;