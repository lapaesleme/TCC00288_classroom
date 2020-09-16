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

insert into pessoa values ('Felipe Vieira','casa');
insert into pessoa values ('Velipe Fieira','apartamento');



select * from pessoa;
