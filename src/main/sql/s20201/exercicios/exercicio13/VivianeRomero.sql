DO $$ BEGIN
    PERFORM drop_functions();
END $$;

drop table if exists campeonato cascade;
drop table if exists time_ cascade;
drop table if exists jogo cascade;

CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer not null,
    CONSTRAINT campeonato_pk PRIMARY KEY (codigo)
);

CREATE TABLE time_ (
    sigla text NOT NULL,
    nome TEXT NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY (sigla)
);

CREATE TABLE jogo (
    campeonato text not null,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer not null,
    gols2 integer not null,
    data_ date not null,
    CONSTRAINT jogo_pk PRIMARY KEY (campeonato,numero),
    CONSTRAINT jogo_campeonato_fk FOREIGN KEY (campeonato) REFERENCES campeonato (codigo),
    CONSTRAINT jogo_time_fk1 FOREIGN KEY (time1) REFERENCES time_ (sigla),
    CONSTRAINT jogo_time_fk2 FOREIGN KEY (time2) REFERENCES time_ (sigla)
);

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('1', 'Campeonato Brasileiro', 2020);

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('2', 'Campeonato Carioca', 2020);

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('3', 'Campeonato Paulista', 2020);

INSERT INTO time_ (sigla, nome)
VALUES ('FLA', 'Flamengo');

INSERT INTO time_ (sigla, nome)
VALUES ('FLU', 'Fluminense');

INSERT INTO time_ (sigla, nome)
VALUES ('VAS', 'Vasco');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('2', 1, 'FLA', 'VAS', 3, 2, '2020-09-30');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 2, 'VAS', 'FLA', 1, 1, '2020-09-30');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 3, 'FLA', 'FLU', 1, 0, '2020-09-30');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('2', 4, 'FLU', 'FLA', 2, 0, '2020-09-30');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 5, 'VAS', 'FLU', 0, 3, '2020-09-30');

INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('2', 6, 'FLU', 'VAS', 3, 2, '2020-09-30');

CREATE OR REPLACE FUNCTION computarClassificacaoCamp(codigoCamp text, posInicial integer, posFinal integer) 
RETURNS TABLE(camp TEXT, time_ TEXT, pontos INTEGER, vitorias INTEGER) AS $$
DECLARE
    contVitorias integer;
    contImpates integer;
    pontuacao float;
    time_camp RECORD;
BEGIN
    DROP TABLE IF EXISTS temp_classificacao;
    CREATE TEMP TABLE temp_classificacao (
        camp TEXT, 
        time_ TEXT, 
        pontos INTEGER, 
        vitorias INTEGER
    );
    FOR time_camp IN SELECT sigla FROM time_ WHERE sigla IN (SELECT time1 FROM jogo WHERE campeonato = codigoCamp) OR sigla IN (SELECT time2 FROM jogo WHERE campeonato = codigoCamp) LOOP
        EXECUTE 'SELECT count(*) FROM jogo WHERE (time1 = $1 AND gols1 > gols2 AND campeonato = $2) OR (time2 = $1 AND gols1 < gols2 AND campeonato = $2)' into contVitorias USING time_camp.sigla, codigoCamp;
        EXECUTE 'SELECT count(*) FROM jogo WHERE (time1 = $1 AND gols1 = gols2 AND campeonato = $2) OR (time2 = $1 AND gols1 = gols2 AND campeonato = $2)' into contImpates USING time_camp.sigla, codigoCamp;
        pontuacao := (contVitorias * 3) + contImpates;
        EXECUTE 'INSERT INTO temp_classificacao VALUES ($1, $2, $3, $4)' USING codigoCamp, time_camp.sigla, pontuacao, contVitorias;
    END LOOP;
    RETURN QUERY SELECT * FROM temp_classificacao ORDER BY(temp_classificacao.pontos, temp_classificacao.vitorias) DESC LIMIT posFinal OFFSET (posInicial - 1);
END
$$ LANGUAGE plpgsql;

SELECT * FROM time_;

SELECT * FROM jogo;

SELECT * FROM computarClassificacaoCamp('1', 1, 3);

SELECT * FROM computarClassificacaoCamp('2', 1, 3);