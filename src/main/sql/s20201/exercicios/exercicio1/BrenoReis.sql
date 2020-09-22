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


insert into pessoa values ('Breno Reis','end');
insert into pessoa values ('Breno','end2');



select * from pessoa;