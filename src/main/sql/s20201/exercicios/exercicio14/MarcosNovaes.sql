DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

drop table if exists bairro cascade;
CREATE TABLE bairro (
    bairro_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT bairro_pk PRIMARY KEY
    (bairro_id)
);

drop table if exists municipio cascade;
CREATE TABLE municipio (
    municipio_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT municipio_pk PRIMARY KEY
    (municipio_id)
);


drop table if exists antena cascade;
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

drop table if exists ligacao cascade;
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
    (numero_dest) REFERENCES antena
    (antena_id)
);



INSERT INTO bairro VALUES(1, 'A');
INSERT INTO bairro VALUES(2, 'B');
INSERT INTO bairro VALUES(3, 'C');
INSERT INTO bairro VALUES(4, 'D');
INSERT INTO bairro VALUES(5, 'E');
INSERT INTO bairro VALUES(6, 'F');
INSERT INTO bairro VALUES(7, 'G');
INSERT INTO bairro VALUES(8, 'H');
INSERT INTO bairro VALUES(9, 'I');

INSERT INTO municipio VALUES(1, 'AA');
INSERT INTO municipio VALUES(2, 'BB');
INSERT INTO municipio VALUES(3, 'CC');

INSERT INTO antena VALUES(1, 1, 1);
INSERT INTO antena VALUES(2, 2, 1);
INSERT INTO antena VALUES(3, 3, 1);
INSERT INTO antena VALUES(4, 4, 2);
INSERT INTO antena VALUES(5, 5, 2);
INSERT INTO antena VALUES(6, 6, 2);
INSERT INTO antena VALUES(7, 7, 3);
INSERT INTO antena VALUES(8, 8, 3);
INSERT INTO antena VALUES(9, 9, 3);


-- ('2000-12-16 07:04:01', '2000-12-16 23:19:06')
INSERT INTO ligacao VALUES(1, 1, 2, 1, 1, '2000-12-16 12:21:13', '2000-12-16 12:22:13');
INSERT INTO ligacao VALUES(2, 2, 1, 1, 2, '2000-12-17 12:22:35', '2000-12-17 12:24:10');
INSERT INTO ligacao VALUES(3, 3, 7, 1, 1, '2000-12-16 12:20:43', '2000-12-16 12:30:03');
INSERT INTO ligacao VALUES(4, 5, 6, 1, 3, '2000-12-16 09:01:13', '2000-12-16 09:08:34');
INSERT INTO ligacao VALUES(5, 10, 9, 2, 1, '2000-12-16 10:44:21', '2000-12-16 11:00:01');
INSERT INTO ligacao VALUES(6, 11, 4, 2, 2, '2000-12-16 07:04:01', '2000-12-16 07:05:39');
INSERT INTO ligacao VALUES(7, 35, 5, 2, 9, '2000-12-16 23:11:56', '2000-12-16 23:19:06');
INSERT INTO ligacao VALUES(8, 21, 2, 2, 8, '2000-12-16 17:21:13', '2000-12-16 17:22:13');
INSERT INTO ligacao VALUES(9, 55, 7, 2, 4, '2000-12-16 13:21:13', '2000-12-16 13:27:13');
INSERT INTO ligacao VALUES(10, 26, 5, 3, 1, '2000-12-16 12:27:13', '2000-12-16 12:54:13');
INSERT INTO ligacao VALUES(11, 31, 8, 3, 7, '2000-12-16 15:46:13', '2000-12-16 15:58:22');
INSERT INTO ligacao VALUES(12, 79, 2, 3, 8, '2000-12-16 12:38:55', '2000-12-16 12:51:53');
INSERT INTO ligacao VALUES(13, 94, 1, 8, 1, '2000-12-16 14:35:13', '2000-12-16 14:40:00');
INSERT INTO ligacao VALUES(14, 66, 6, 8, 2, '2000-12-16 18:40:13', '2000-12-16 18:43:27');
INSERT INTO ligacao VALUES(15, 420, 9, 6, 3, '2000-12-16 04:20:06', '2000-12-16 04:20:09');
INSERT INTO ligacao VALUES(16, 581, 3, 4, 4, '2000-12-16 05:44:55', '2000-12-16 05:59:59');
INSERT INTO ligacao VALUES(17, 81, 2, 4, 4, '2000-12-16 10:37:27', '2000-12-16 10:47:33');
INSERT INTO ligacao VALUES(18, 197, 1, 3, 6, '2000-12-16 11:55:10', '2000-12-16 12:08:10');



CREATE OR REPLACE FUNCTION duracaoMediaPorRegiao(intervaloInicio timestamp, intervaloFim timestamp)
    RETURNS TABLE(bairro TEXT, municipio TEXT, duracaoMedia float)
    AS $$
    DECLARE
        ligacoesParticipantes CURSOR FOR SELECT *  FROM ligacao WHERE inicio >= intervaloInicio AND fim <= intervaloFim UNION SELECT *  FROM ligacao WHERE inicio >= intervaloInicio AND fim <= intervaloFim;
        antenasParticipantes CURSOR FOR (SELECT antena_orig AS antenaPa, bairro_id, municipio_id FROM ligacao INNER JOIN antena ON antena.antena_id = ligacao.antena_orig WHERE inicio >= intervaloInicio AND fim <= intervaloFim  UNION SELECT antena_dest AS antenaPa, bairro_id, municipio_id FROM ligacao INNER JOIN antena ON antena.antena_id = ligacao.antena_dest WHERE inicio >= intervaloInicio AND fim <= intervaloFim );
        numLigacoes integer default 0;
        tempoMinutos float default 0;
        tempoAbsolutoLigacao interval;
        municipioAtual text;
        bairroAtual text;
        media float default 0;
    BEGIN
        FOR antena IN antenasParticipantes loop
          FOR ligacao IN ligacoesParticipantes loop
            IF ligacao.antena_orig = antena.antenaPa OR ligacao.antena_dest = antena.antenaPa THEN
                numLigacoes := numLigacoes + 1;
                tempoAbsolutoLigacao := ligacao.fim - ligacao.inicio;
                tempoMinutos := extract(minute from tempoAbsolutoLigacao);
                tempoMinutos := tempoMinutos + extract(second from tempoAbsolutoLigacao)/60;
                tempoMinutos := tempoMinutos + extract(hour from tempoAbsolutoLigacao)*60;
                tempoMinutos := tempoMinutos + extract(day from tempoAbsolutoLigacao)*24*60;
            END IF;
          end loop;
          SELECT nome FROM bairro WHERE bairro_id = antena.bairro_id INTO bairroAtual;
          SELECT nome FROM municipio WHERE municipio_id = antena.municipio_id INTO municipioAtual;
          media := round((tempoMinutos / numLigacoes)::numeric, 2);
          RETURN QUERY SELECT bairroAtual, municipioAtual, media;
          media := 0;
          numLigacoes := 0;
          tempoMinutos := 0;
        end loop;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION tabelaOrdenadaDeDuracaoMedia(intervaloInicio timestamp, intervaloFim timestamp)
    RETURNS TABLE(bairro TEXT, municipio TEXT, duracaoMedia float)
    AS $$
    DECLARE
        
    BEGIN
        RETURN QUERY SELECT * FROM duracaoMediaPorRegiao(intervaloInicio, intervaloFim) ORDER BY duracaoMedia DESC;
    END;
$$
LANGUAGE PLPGSQL;

SELECT tabelaOrdenadaDeDuracaoMedia('2000-12-16 00:00:00', '2000-12-16 23:59:00');