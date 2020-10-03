DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

drop table if exists campeonato cascade;
CREATE TABLE campeonato (
codigo text NOT NULL,
nome TEXT NOT NULL,
ano integer not null,
CONSTRAINT campeonato_pk PRIMARY KEY
(codigo));

drop table if exists time_ cascade;
CREATE TABLE time_ (
sigla text NOT NULL,
nome TEXT NOT NULL,
CONSTRAINT time_pk PRIMARY KEY
(sigla));

drop table if exists jogo cascade;
CREATE TABLE jogo (
campeonato text not null,
numero integer NOT NULL,
time1 text NOT NULL,
time2 text NOT NULL,
gols1 integer not null,
gols2 integer not null,
data_ date not null,
CONSTRAINT jogo_pk PRIMARY KEY
(campeonato,numero),
CONSTRAINT jogo_campeonato_fk FOREIGN KEY
(campeonato) REFERENCES campeonato
(codigo),
CONSTRAINT jogo_time_fk1 FOREIGN KEY
(time1) REFERENCES time_ (sigla),
CONSTRAINT jogo_time_fk2 FOREIGN KEY
(time2) REFERENCES time_ (sigla));

INSERT INTO campeonato VALUES ('C1', 'Campeonato 1', 2010);

INSERT INTO time_ VALUES ('FLU','Fluminense');
INSERT INTO time_ VALUES ('FLA','Flamengo');
INSERT INTO time_ VALUES ('BOT','Botafogo');
INSERT INTO time_ VALUES ('VAS','Vasco');
INSERT INTO time_ VALUES ('AME','America');
INSERT INTO time_ VALUES ('BAN','Bangu');

INSERT INTO jogo VALUES ('C1',1,'FLU','FLA',3,0,'2010-05-10');
INSERT INTO jogo VALUES ('C1',2,'BOT','VAS',1,1,'2010-05-11');
INSERT INTO jogo VALUES ('C1',3,'AME','BAN',1,2,'2010-05-12');
INSERT INTO jogo VALUES ('C1',4,'FLU','BAN',3,3,'2010-06-10');
INSERT INTO jogo VALUES ('C1',5,'BOT','FLA',0,1,'2010-06-11');
INSERT INTO jogo VALUES ('C1',6,'AME','VAS',0,0,'2010-06-12');

DROP FUNCTION IF EXISTS classifica(codigoCampeonato text);
CREATE OR REPLACE FUNCTION classifica(codigoCampeonato text) RETURNS TABLE(nomeTime TEXT, pontos integer, vitorias integer, empates integer) AS $$
DECLARE
    tuplaCampeonato RECORD;
    tuplaTimesCampeonato RECORD;
    vitorias integer := 0;
    empates integer := 0;
    pontuacaoFinal integer := 0;
BEGIN
    FOR tuplaTimesCampeonato IN SELECT time_.sigla FROM time_ JOIN jogo ON (time_.sigla = jogo.time1) UNION SELECT time_.sigla FROM time_ JOIN jogo ON (time_.sigla = jogo.time2) LOOP
        FOR tuplaCampeonato IN SELECT time1, time2, gols1, gols2 FROM jogo JOIN campeonato ON(jogo.campeonato = campeonato.codigo) WHERE jogo.campeonato = codigoCampeonato LOOP
            IF tuplaCampeonato.gols1 = tuplaCampeonato.gols2 AND (tuplaCampeonato.time1 = tuplaTimesCampeonato.sigla OR tuplaCampeonato.time2 = tuplaTimesCampeonato.sigla) THEN
                empates := empates + 1;
                pontuacaoFinal := pontuacaoFinal + 1;
            ELSIF tuplaCampeonato.gols1 > tuplaCampeonato.gols2 AND tuplaCampeonato.time1 = tuplaTimesCampeonato.sigla THEN
                vitorias := vitorias + 1;
                pontuacaoFinal := + 3;
            ELSIF tuplaCampeonato.gols1 < tuplaCampeonato.gols2 AND tuplaCampeonato.time2 = tuplaTimesCampeonato.sigla THEN
                vitorias := vitorias + 1;
                pontuacaoFinal := + 3;
            END IF;
        END LOOP;
        RETURN QUERY SELECT tuplaTimesCampeonato.sigla, pontuacaoFinal, vitorias, empates;
        pontuacaoFinal := 0;
        vitorias := 0;
        empates := 0;
    END LOOP;
    RETURN;
END
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS classificacaoFinal(codigoCampeonato text, ranqueInicial integer, ranqueFinal integer);
CREATE OR REPLACE FUNCTION classificacaoFinal(codigoCampeonato text, ranqueInicial integer, ranqueFinal integer) RETURNS TABLE(nomeTime TEXT, pontos integer, vitorias integer, empates integer) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM classifica(codigoCampeonato) ORDER BY pontos DESC LIMIT ranqueFinal-ranqueInicial+1 OFFSET ranqueInicial-1; 
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM classificacaoFinal('C1', 1, 6);