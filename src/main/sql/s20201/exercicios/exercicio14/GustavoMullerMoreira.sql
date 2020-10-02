DO $$ BEGIN
    PERFORM drop_functions();
END $$;

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

INSERT INTO bairro VALUES (1, 'Bairro A');
INSERT INTO bairro VALUES (2, 'Bairro B');

INSERT INTO municipio VALUES (1, 'Municipio A');
INSERT INTO municipio VALUES (2, 'Municipio B');

INSERT INTO antena VALUES (1, 1, 1);
INSERT INTO antena VALUES (2, 2, 2);

INSERT INTO ligacao VALUES (1, 1111, 2222, 1, 2, '2004-10-19 10:23:54', '2004-10-19 10:28:54');
INSERT INTO ligacao VALUES (2, 2222, 3333, 2, 1, '2004-11-19 09:15:20', '2004-11-19 10:00:20');
INSERT INTO ligacao VALUES (3, 3333, 1111, 1, 1, '2014-12-25 07:00:00', '2014-12-25 07:32:23');
INSERT INTO ligacao VALUES (4, 1111, 3333, 1, 1, '2020-10-19 10:23:54', '2020-10-19 10:25:30');
INSERT INTO ligacao VALUES (5, 11121, 22322, 1, 2, '2005-10-19 10:23:54', '2005-10-19 10:24:54');

CREATE or REPLACE FUNCTION avgDuracao(tempo1 timestamp, tempo2 timestamp) RETURNS Table(bairro_orig integer, municipio_orig integer, bairro_dest integer, municipio_dest integer, duracao interval) AS $$
DECLARE
    linha RECORD;
BEGIN

drop table if exists regiao cascade;

CREATE TEMP TABLE regiao(
    bairro_orig integer NOT NULL,
    municipio_orig integer NOT NULL,
    bairro_dest integer NOT NULL,
    municipio_dest integer NOT NULL,    
    duracao interval NOT NULL
);

    FOR linha IN SELECT * FROM ligacao LOOP
        IF tempo1 < linha.inicio AND linha.fim < tempo2 THEN
            WITH regiao_antena as (
                SELECT b.bairro_id, m.municipio_id, a.antena_id 
                FROM bairro as b, municipio as m, antena as a 
                WHERE a.bairro_id = b.bairro_id AND a.municipio_id = m.municipio_id 
            )
            INSERT INTO regiao
                   VALUES(
                        (SELECT ra.bairro_id FROM regiao_antena as ra WHERE ra.antena_id = linha.antena_orig), 
                        (SELECT ra.municipio_id FROM regiao_antena as ra WHERE ra.antena_id = linha.antena_orig), 
                        (SELECT ra.bairro_id FROM regiao_antena as ra WHERE ra.antena_id = linha.antena_dest), 
                        (SELECT ra.municipio_id FROM regiao_antena as ra WHERE ra.antena_id = linha.antena_dest), 
                        linha.fim-linha.inicio); 
        END IF;
    END LOOP;

    RETURN QUERY SELECT r.bairro_orig, r.municipio_orig, r.bairro_dest, r.municipio_dest, AVG(r.duracao) as duracao_avg  FROM regiao as r GROUP BY (r.bairro_orig, r.municipio_orig, r.bairro_dest, r.municipio_dest) ORDER BY duracao_avg DESC;

END;
$$ LANGUAGE plpgsql;

/* Mostra o tempo medio das ligacoes feitas entre determinado intervalo de tempo*/
/* As medias sao agrupadas por regiao (bairro_id, municipio_id) e a direcao da ligacao importa*/
SELECT * FROM avgDuracao('2004-10-19 10:23:53', '2021-11-19 10:00:21'); /*Mostra todas as ligacoes e a media feita na linha 2 e 3*/
SELECT * FROM avgDuracao('2004-10-19 10:23:53', '2006-11-19 10:00:21'); /*Somente 3 das 5 sao ligacoes desse intervalo e a media eh tirada entre a de id 1 e 5*/
