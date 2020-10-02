DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE if exists bairro cascade;
CREATE TABLE bairro (
    bairro_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT bairro_pk PRIMARY KEY
    (bairro_id)
);

DROP TABLE if exists municipio cascade;
CREATE TABLE municipio (
    municipio_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT municipio_pk PRIMARY KEY
    (municipio_id)
);

DROP TABLE if exists antena cascade;
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
    (municipio_id)
);

DROP TABLE if exists ligacao cascade;
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
    (antena_id)
);

INSERT INTO bairro(bairro_id, nome)
VALUES(1, 'Flamengo');

INSERT INTO bairro(bairro_id, nome)
VALUES(2, 'Botafogo');

INSERT INTO bairro(bairro_id, nome)
VALUES(3, 'Jacarepaguá');

INSERT INTO bairro(bairro_id, nome)
VALUES(4, 'Realengo');

INSERT INTO municipio(municipio_id, nome)
VALUES(1, 'Rio de Janeiro');

INSERT INTO antena(antena_id, bairro_id, municipio_id)
VALUES(1, 1, 1);

INSERT INTO antena(antena_id, bairro_id, municipio_id)
VALUES(2, 2, 1);

INSERT INTO antena(antena_id, bairro_id, municipio_id)
VALUES(3, 3, 1);

INSERT INTO antena(antena_id, bairro_id, municipio_id)
VALUES(4, 4, 1);

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(1, 99999999, 11111111, 1, 4, '2020-09-15 12:00:00', '2020-09-15 12:01:12'); --Tempo de Chamada: 01:12

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(2, 99999999, 11111111, 1, 4, '2020-09-15 12:35:00', '2020-09-15 12:35:32'); --Tempo de Chamada: 00:32

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(3, 99999999, 11111111, 1, 4, '2020-09-12 12:42:10', '2020-09-12 12:44:50'); --Tempo de Chamada: 02:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(4, 88888888, 22222222, 2, 3, '2020-09-14 13:42:10', '2020-09-14 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(5, 88888888, 22222222, 2, 3, '2020-09-13 13:42:10', '2020-09-13 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(6, 88888888, 22222222, 2, 3, '2020-09-15 13:42:10', '2020-09-15 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(7, 88888888, 22222222, 2, 3, '2020-09-20 13:43:10', '2020-09-20 13:43:50'); --Tempo de Chamada: 00:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(8, 77777777, 33333333, 1, 3, '2020-09-20 13:43:10', '2020-09-20 14:03:20'); --Tempo de Chamada: 20:10

CREATE OR REPLACE FUNCTION region_call_duration(data_hora1 timestamp, data_hora2 timestamp) RETURNS TABLE(municipio_id integer, bairro_id integer, avg_call_duration interval) AS $$
DECLARE
BEGIN
    DROP TABLE if exists Region cascade;
    CREATE TABLE Region(
        municipio_id integer,
        bairro_id integer,
        avg_call_duration interval
    );

    INSERT INTO Region 
        SELECT antena.municipio_id, antena.bairro_id, AVG(ligacao.fim - ligacao.inicio) AS avg_call_duration FROM ligacao, antena
        WHERE ((ligacao.antena_orig = antena.antena_id OR ligacao.antena_dest = antena.antena_id) AND (data_hora1 < ligacao.inicio) AND (data_hora1 < ligacao.fim) AND (data_hora2 > ligacao.inicio) AND (data_hora2 > ligacao.fim))
        GROUP BY antena.bairro_id, antena.municipio_id;
 
    RETURN QUERY SELECT * FROM Region;
END
$$ LANGUAGE plpgsql;

SELECT * FROM region_call_duration('2020-09-15 00:00:00', '2020-09-15 23:59:59');
