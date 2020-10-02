drop function if exists mediaHorario cascade;
drop table if exists bairro cascade;
drop table if exists municipio cascade;
drop table if exists antena cascade;
drop table if exists ligacao cascade;



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
    (7, 999999999, 988888888, 1, 7, '2016-04-29 00:00:00', '2016-04-29 00:09:00');










create or replace function mediaHorario(limiteInferior timestamp, limiteSuperior timestamp)
 returns table(
     bairro_1 integer,
     municipio_1 integer,
     bairro_2 integer,
     municipio_2 integer,
     quantidadeLigacoes integer,
     tempoigacoes integer,
     TempoMedio real
)
 as $$
declare
    antenaRecord1 Record;
    antenaRecord2 Record;
    duracaoMediaRecord Record;
    ligacaoRecord Record;
    regiao1 Record;
    regiao2 Record;
    diferenca integer;
begin

    drop table if exists duracaoMedia cascade;
    
    CREATE TABLE duracaoMedia (
        bairro_id_1 integer NOT NULL,
        municipio_id_1 integer NOT NULL,
        bairro_id_2 integer NOT NULL,
        municipio_id_2 integer NOT NULL,
        quantidade_ligacoes integer,
        tempo_ligacoes integer
    );

    --cria pareamento reigiao - regiao na tabela duracao media(baseado nas regioes que possuem antenas)
    for antenaRecord1 in select * from antena loop
        for antenaRecord2 in select * from antena where antena.antena_id >= antenaRecord1.antena_id loop
              if not exists(select * 
                            from duracaoMedia
                            where
                            (antenaRecord1.bairro_id = bairro_id_1 and antenaRecord1.municipio_id = municipio_id_1 and antenaRecord2.bairro_id = bairro_id_2 and antenaRecord2.municipio_id = municipio_id_2) 
                            or (antenaRecord1.bairro_id = bairro_id_2 and antenaRecord1.municipio_id = municipio_id_2 and antenaRecord2.bairro_id = bairro_id_1 and antenaRecord2.municipio_id = municipio_id_1) 
                )then
                insert into duracaoMedia values(antenaRecord1.bairro_id, antenaRecord1.municipio_id, antenaRecord2.bairro_id, antenaRecord2.municipio_id, 0, 0);
              end if;
        end loop;
    end loop;
    

    --checa quais regioes tiveram ligacoes entre si e atualiza as que não são zero
    for ligacaoRecord in select * from ligacao loop
        if(ligacaoRecord.inicio > limiteInferior and ligacaoRecord.fim < limiteSuperior) then
            select municipio_id, bairro_id into regiao1 from antena where antena_id = ligacaoRecord.antena_orig;
            select municipio_id, bairro_id into regiao2 from antena where antena_id = ligacaoRecord.antena_dest;
            select * into duracaoMediaRecord from duracaoMedia where(bairro_id_1 = regiao1.bairro_id and bairro_id_2 = regiao2.bairro_id and municipio_id_1 = regiao1.municipio_id and municipio_id_2 = regiao2.municipio_id)
                or (bairro_id_2 = regiao1.bairro_id and bairro_id_1 = regiao2.bairro_id and municipio_id_2 = regiao1.municipio_id and municipio_id_1 = regiao2.municipio_id);
            
            diferenca := EXTRACT(MINUTE from ligacaoRecord.inicio - ligacaoRecord.fim);
            
            update duracaoMedia set quantidade_ligacoes = duracaoMedia.quantidade_ligacoes + 1, tempo_ligacoes = duracaoMedia.tempo_ligacoes +  abs(diferenca)
             where bairro_id_1 = duracaoMediaRecord.bairro_id_1 and bairro_id_2 = duracaoMediaRecord.bairro_id_2 and  municipio_id_1 = duracaoMediaRecord.municipio_id_1 and municipio_id_2 = duracaoMediaRecord.municipio_id_2;
        
        end if;
    end loop;


    return query select *, case when quantidade_ligacoes = 0 then 0 else cast(tempo_ligacoes as real)/cast(quantidade_ligacoes as real) end as tempoMedio from duracaoMedia order by case when quantidade_ligacoes = 0 then 0 else cast(tempo_ligacoes as real)/cast(quantidade_ligacoes as real) end desc;
END
$$ LANGUAGE plpgsql;


select mediaHorario('2016-04-28 00:00:00', '2016-04-29 01:00:00');
select (bairro_id_1, municipio_id_1)as regiao1, (bairro_id_2, municipio_id_2)as regiao2, quantidade_ligacoes as "quantidade de ligacoes", tempo_ligacoes as "tempo de ligacoes(em segundos)" , case when quantidade_ligacoes = 0 then 0 else cast(tempo_ligacoes as real)/cast(quantidade_ligacoes as real) end as "tempo medio" from duracaoMedia order by case when quantidade_ligacoes = 0 then 0 else cast(tempo_ligacoes as real)/cast(quantidade_ligacoes as real) end desc;