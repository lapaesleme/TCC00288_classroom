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
    (bairro_id)
);
CREATE TABLE municipio (
    municipio_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT municipio_pk PRIMARY KEY
    (municipio_id)
);
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

INSERT INTO bairro VALUES (1, 'Botafogo');
INSERT INTO bairro VALUES (2, 'Ipanema');
INSERT INTO bairro VALUES (3, 'Sao Domingos');
INSERT INTO bairro VALUES (4, 'Icarai');

INSERT INTO municipio VALUES (1, 'Rio de Janeiro');
INSERT INTO municipio VALUES (2, 'Niteroi');

INSERT INTO antena VALUES (1, 1, 1);
INSERT INTO antena VALUES (2, 2, 1);
INSERT INTO antena VALUES (3, 2, 1);
INSERT INTO antena VALUES (4, 3, 2);
INSERT INTO antena VALUES (5, 4, 2);
INSERT INTO antena VALUES (6, 4, 2);

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(3, 99999999, 11111111, 1, 4, '2020-09-12 12:42:10', '2020-09-12 12:44:50'); --Tempo de Chamada: 02:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(5, 88888888, 22222222, 2, 3, '2020-09-13 13:42:10', '2020-09-13 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(4, 88888888, 22222222, 2, 3, '2020-09-14 13:42:10', '2020-09-14 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(1, 99999999, 11111111, 1, 4, '2020-09-15 12:00:00', '2020-09-15 12:01:12'); --Tempo de Chamada: 01:12

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(2, 99999999, 11111111, 1, 4, '2020-09-15 12:35:00', '2020-09-15 12:35:32'); --Tempo de Chamada: 00:32

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(6, 88888888, 22222222, 2, 3, '2020-09-15 13:42:10', '2020-09-15 13:43:50'); --Tempo de Chamada: 01:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(7, 88888888, 22222222, 2, 3, '2020-09-20 13:43:10', '2020-09-20 13:43:50'); --Tempo de Chamada: 00:40

INSERT INTO ligacao(ligacao_id, numero_orig, numero_dest, antena_orig, antena_dest, inicio, fim)
VALUES(8, 77777777, 33333333, 1, 3, '2020-09-20 13:43:10', '2020-09-20 14:03:20'); --Tempo de Chamada: 20:10

CREATE OR REPLACE FUNCTION listarDuracaoMediaLigacoes(datahora1 timestamp, datahora2 timestamp) 
RETURNS TABLE(municipio varchar, bairro varchar, duracao_media_ligacao interval) AS $$
DECLARE
    munic RECORD;
    bair RECORD;
    ant RECORD;
    lig RECORD;
BEGIN
    DROP TABLE IF EXISTS temp_lista;
    CREATE TEMP TABLE temp_lista (
        mun varchar, 
        ba varchar, 
        duracao_media interval
    );
    
    FOR munic IN SELECT * FROM municipio LOOP
        FOR bair IN SELECT * FROM bairro, antena WHERE municipio_id = munic.municipio_id LOOP
            FOR ant IN SELECT * FROM antena WHERE municipio_id = munic.municipio_id AND bairro_id = bair.bairro_id LOOP
                FOR lig IN SELECT * FROM ligacao WHERE antena_orig = ant.antena_id OR antena_dest = ant.antena_id LOOP
                    IF (datahora1 <= lig.inicio) AND (datahora2 >= lig.fim) THEN
                        EXECUTE 'INSERT INTO temp_lista VALUES ($1, $2, $3)' USING munic.nome, bair.nome, lig.fim - lig.inicio;
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT mun, ba, AVG(duracao_media) FROM temp_lista GROUP BY (mun, ba) ORDER BY AVG(duracao_media) DESC;
END
$$ LANGUAGE plpgsql;

SELECT * FROM listarDuracaoMediaLigacoes('2020-09-15 00:00:00', '2020-09-15 23:59:59');

SELECT * FROM listarDuracaoMediaLigacoes('2020-09-20 00:00:00', '2020-09-20 23:59:59');