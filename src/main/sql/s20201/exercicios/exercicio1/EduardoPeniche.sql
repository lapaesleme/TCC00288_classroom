drop table if exists pessoa  cascade;
create table pessoa(
nome varchar,
endereco varchar
);
insert into pessoa values ('Eduardo Peniche','end');
insert into pessoa values ('Eduardo','end2');

select * from pessoa;
