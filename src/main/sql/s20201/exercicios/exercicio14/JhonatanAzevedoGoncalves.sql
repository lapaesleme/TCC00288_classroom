/*Dado o esquema de BD apresentado a seguir, escreva uma função em PL/pgSQL para listar
a duração média de ligação telefônica entre regiões em um período de tempo [data/hora
1,data/hora 2] a ser informado como parâmetro. A listagem deve ser ordenada em ordem
decrescente de duração média. Uma região é identificada por um par (bairro,município).*/

drop table if exists bairro cascade;
drop table if exists municipio cascade;
drop table if exists antena cascade;
drop table if exists ligacao cascade;
drop table if exists duracaomedia cascade;



CREATE TABLE bairro (
bairro_id integer NOT NULL,
nome character varying NOT NULL,
CONSTRAINT bairro_pk PRIMARY KEY
(bairro_id));

CREATE TABLE municipio (
municipio_id integer NOT NULL,
nome character varying NOT NULL,
CONSTRAINT municipio_pk PRIMARY KEY
(municipio_id));

CREATE TABLE antena (
antena_id integer NOT NULL,
bairro_id integer NOT NULL,
municipio_id integer NOT NULL,
CONSTRAINT antena_pk PRIMARY KEY
(antena_id),
CONSTRAINT bairro_fk FOREIGN KEY
(bairro_id) REFERENCES bairro
(bairro_id),
CONSTRAINT municipio_fk FOREIGN KEY
(municipio_id) REFERENCES municipio
(municipio_id));



INSERT INTO bairro values
    (1, 'Freguesia'),
    (2, 'Pechincha'),
    (3, 'Penha'),
    (4, 'Tanque'),
    (5, 'Araras'),
    (6, 'Ingá'),
    (7, 'Icaraí');

INSERT INTO municipio values
    (1, 'Rio de Janeiro'),
    (2, 'Petropolis'),
    (3, 'Niteroi');



INSERT INTO antena values
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 1),
    (5, 5, 2),
    (6, 6, 3),
    (7, 7, 3);


CREATE TABLE ligacao (
ligacao_id bigint NOT NULL,
numero_orig integer NOT NULL,
numero_dest integer NOT NULL,
antena_orig integer NOT NULL,
antena_dest integer NOT NULL,
inicio timestamp NOT NULL,
fim timestamp NOT NULL,
CONSTRAINT ligacao_pk PRIMARY KEY
(ligacao_id),
CONSTRAINT antena_orig_fk FOREIGN KEY
(antena_orig) REFERENCES antena
(antena_id),
CONSTRAINT antena_dest_fk FOREIGN KEY
(antena_dest) REFERENCES antena
(antena_id));


INSERT INTO ligacao values
    (1, 999999999, 988888888, 7, 1, '2016-04-29 00:00:00', '2016-04-29 00:01:00'),
    (2, 999999999, 988888888, 1, 2, '2016-04-29 00:00:00', '2016-04-29 00:02:00'),
    (3, 999999999, 988888888, 1, 5, '2016-04-29 00:00:00', '2016-04-29 00:03:00'),
    (4, 999999999, 988888888, 1, 4, '2016-04-29 00:00:00', '2016-04-29 00:04:00'),
    (5, 999999999, 988888888, 2, 5, '2016-04-29 00:00:00', '2016-04-29 00:05:00'),
    (6, 999999999, 988888888, 1, 6, '2016-04-29 00:00:00', '2016-04-29 00:06:00'),
    (8, 999999999, 988888888, 7, 1, '2016-04-29 00:00:00', '2016-04-29 00:08:00'),
    (7, 999999999, 988888888, 1, 7, '2016-04-29 00:00:00', '2016-04-29 00:09:00');


DROP FUNCTION if exists mediahorario(timestamp without time zone,timestamp without time zone);

create or replace function mediaHorario(d1 timestamp, d2 timestamp) returns table(bairro_id_1 integer,municipio_id_1 integer,bairro_id_2 integer,municipio_id_2 integer,quantidade_ligacoes bigint, media interval) as $$
 declare
 
 begin
	return query
 	with 
		lig_periodo as( select * from ligacao where ligacao.inicio >=d1 and ligacao.fim<=d2 ),
		lig_regiao as (select lig_periodo.ligacao_id, lig_periodo.numero_orig, lig_periodo.numero_dest, lig_periodo.antena_orig, lig_periodo.antena_dest, age(lig_periodo.fim, lig_periodo.inicio) as duracao, a1.bairro_id as bairro_orig, a1.municipio_id as municipio_orig, a2.bairro_id as bairro_dest, a2.municipio_id as municipio_dest from lig_periodo inner join antena as a1 on lig_periodo.antena_orig = a1.antena_id inner join antena as a2 on lig_periodo.antena_dest = a2.antena_id)
	select bairro_orig, municipio_orig, bairro_dest, municipio_dest, count(*) as quantidade_ligacoes, sum(duracao)/count(*) as media from lig_regiao group by bairro_orig, municipio_orig, bairro_dest, municipio_dest;
 end
$$ language plpgsql;

select * from mediaHorario('2016-04-29 00:00:00', '2016-04-29 00:09:00')

