/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 3 de out. de 2020
 */


DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists bairro cascade;
drop table if exists municipio cascade;
drop table if exists antena cascade;
drop table if exists ligacao cascade;

create table bairro(
    bairro_id integer NOT NULL,
    nome character varying NOT NULL,
    constraint bairro_pk primary key (bairro_id)
);

create table municipio(
    municipio_id integer NOT NULL,
    nome character varying NOT NULL,
    constraint municipio_pk primary key (municipio_id)
);

create table antena(
    antena_id integer NOT NULL,
    bairro_id integer NOT NULL,
    municipio_id integer NOT NULL,
    constraint antena_pk primary key (antena_id),
    constraint bairro_fk foreign key (bairro_id) references bairro (bairro_id),
    constraint antenta_fk foreign key (antena_id) references antena (antena_id)
);

create table ligacao(
    ligacao_id integer NOT NULL,
    numero_orig integer NOT NULL,
    numero_dest integer NOT NULL,
    antena_orig integer NOT NULL,
    antena_dest integer NOT NULL,
    inicio timestamp NOT NULL,
    fim timestamp NOT NULL,
    constraint ligacao_pk primary key (ligacao_id),
    constraint antena_orig_fk foreign key (antena_orig) references antena (antena_id),
    constraint antena_dest_fk foreign key (antena_dest) references antena (antena_id)
);

insert into bairro values (1, 'Tijuca');
insert into bairro values (2, 'Meier');
insert into bairro values (3, 'Ipanema');
insert into bairro values (4, 'Icarai');
insert into bairro values (5, 'Inga');
insert into bairro values (6, 'Morumbi');
insert into bairro values (7, 'Pinheiros');

insert into municipio values (1, 'Rio de Janeiro');
insert into municipio values (2, 'Niteroi');
insert into municipio values (3, 'Sao Paulo');

insert into antena values (1, 1, 1);
insert into antena values (2, 1, 1);
insert into antena values (3, 2, 1);
insert into antena values (4, 3, 1);
insert into antena values (5, 4, 2);
insert into antena values (6, 5, 2);
insert into antena values (7, 6, 3);
insert into antena values (8, 7, 3);
insert into antena values (9, 7, 3);

insert into ligacao values (1, 2453, 1754, 1, 2, '2020-9-12 10:23:54', '2020-9-12 10:33:57'); /* tijuca -> tijuca */
insert into ligacao values (2, 2453, 1754, 1, 2, '2020-9-12 11:23:54', '2020-9-12 12:33:57'); /* tijuca -> tijuca */
insert into ligacao values (3, 1287, 0518, 1, 3, '2020-9-27 17:23:41', '2020-9-27 18:31:32'); /* tijuca -> meier */
insert into ligacao values (4, 3425, 8741, 4, 5, '2020-9-15 13:23:54', '2020-9-15 13:43:57'); /* ipanema -> icarai */
insert into ligacao values (5, 1058, 8963, 4, 2, '2020-9-12 18:17:24', '2020-9-12 20:34:21'); /* ipanema -> tijuca */
insert into ligacao values (6, 6512, 4158, 1, 6, '2020-9-19 21:17:24', '2020-9-19 23:51:43'); /* tijuca -> inga */
insert into ligacao values (7, 6512, 4158, 7, 7, '2020-9-21 11:12:14', '2020-9-21 11:14:23'); /* morumbi -> morumbi */

drop function if exists duracaoMedia(tempo1 timestamp, tempo2 timestamp) cascade;

create or replace function duracaoMedia(tempo1 timestamp, tempo2 timestamp) returns
    table(bairro_orig character varying, municipio_orig character varying, 
          bairro_dest character varying, municipio_dest character varying, duracao interval) as $$
declare
    chamada RECORD;
begin
    drop table if exists regiao cascade;
    create TEMP table regiao(bairro_orig character varying, municipio_orig character varying , 
                            bairro_dest character varying, municipio_dest character varying, duracao interval);

    for chamada in select * from ligacao loop
        if chamada.inicio >= tempo1 and chamada.fim <= tempo2 then  
            insert into regiao values(
                (select b.nome from antena as a inner join bairro as b on (a.bairro_id = b.bairro_id) 
                    where a.antena_id = chamada.antena_orig), 
                (select m.nome from antena as a inner join municipio as m on (a.municipio_id = m.municipio_id) 
                    where a.antena_id = chamada.antena_orig), 
                (select b.nome from antena as a inner join bairro as b on (a.bairro_id = b.bairro_id) 
                    where a.antena_id = chamada.antena_dest), 
                (select m.nome from antena as a inner join municipio as m on (a.municipio_id = m.municipio_id) 
                    where a.antena_id = chamada.antena_dest), 
                (chamada.fim - chamada.inicio)
            ); 
                /*raise notice '%', chamada.fim-chamada.inicio;*/
        end if;
    end loop;
  
    return query select r.bairro_orig, r.municipio_orig, r.bairro_dest, r.municipio_dest, avg(r.duracao) as duracao_media
        from regiao as r group by (r.bairro_orig, r.municipio_orig, r.bairro_dest, r.municipio_dest) 
        order by duracao_media desc;

    /*return query select * from regiao;*/

end
$$
language plpgsql;


select * from duracaoMedia('2020-9-12 10:23:54', '2020-9-27 18:31:32');
select * from duracaoMedia('2020-9-15 13:23:54', '2020-9-19 23:51:43');