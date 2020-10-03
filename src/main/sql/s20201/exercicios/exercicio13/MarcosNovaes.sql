DO $$ BEGIN
    PERFORM drop_functions(); 
END $$;

drop table if exists campeonato cascade;

CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer not null,
    CONSTRAINT campeonato_pk PRIMARY KEY
    (codigo)
);

drop table if exists time_ cascade;

CREATE TABLE time_ (
    sigla text NOT NULL,
    nome TEXT NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY
    (sigla)
);

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
    (time2) REFERENCES time_ (sigla)
);

INSERT INTO campeonato VALUES('CAR20', 'CAMPEONATO CARIOCA 2020', 2020);


INSERT INTO time_ VALUES('BOT', 'BOTAFOGO');
INSERT INTO time_ VALUES('FLU', 'FLUMINENSE');
INSERT INTO time_ VALUES('VAS', 'VASCO');
INSERT INTO time_ VALUES('FLA', 'FLAMENGO');
INSERT INTO time_ VALUES('PAL', 'PALMEIRAS');
INSERT INTO time_ VALUES('COR', 'CORINTHIANS');
INSERT INTO time_ VALUES('SAN', 'SANTOS');
INSERT INTO time_ VALUES('SPA', 'SAO PAULO');

INSERT INTO jogo VALUES('CAR20', 1, 'BOT', 'FLA', 3, 0, '15/01/2020');
INSERT INTO jogo VALUES('CAR20', 3, 'BOT', 'FLU', 1, 0, '18/01/2020');
INSERT INTO jogo VALUES('CAR20', 5, 'BOT', 'VAS', 2, 1, '21/01/2020');
INSERT INTO jogo VALUES('CAR20', 6, 'FLU', 'FLA', 1, 1, '21/01/2020');
INSERT INTO jogo VALUES('CAR20', 2, 'FLU', 'VAS', 1, 1, '15/01/2020');
INSERT INTO jogo VALUES('CAR20', 7, 'FLU', 'BOT', 2, 0, '24/01/2020');
INSERT INTO jogo VALUES('CAR20', 4, 'VAS', 'FLA', 1, 1, '18/01/2020');
INSERT INTO jogo VALUES('CAR20', 9, 'VAS', 'FLU', 1, 1, '27/01/2020');
INSERT INTO jogo VALUES('CAR20', 11, 'VAS', 'BOT', 2, 0, '30/01/2020');
INSERT INTO jogo VALUES('CAR20', 12, 'FLA', 'FLU', 0, 2, '30/01/2020');
INSERT INTO jogo VALUES('CAR20', 8, 'FLA', 'VAS', 2, 2, '24/01/2020');
INSERT INTO jogo VALUES('CAR20', 10, 'FLA', 'BOT', 1, 0, '27/01/2020');


CREATE OR REPLACE FUNCTION computaTabela(codCamp text)
    RETURNS TABLE(clube TEXT, pontos integer, nJogos integer , vitorias integer, empates integer, derrotas integer)
    AS $$
    DECLARE
        timesParticipantes CURSOR FOR SELECT sigla, nome FROM time_ WHERE sigla IN (SELECT time1 FROM jogo WHERE campeonato = codCamp) OR sigla IN (SELECT time2 FROM jogo WHERE campeonato = codCamp);
        vitoriasTimeAtual integer default 0;
        pontosTimeAtual integer default 0;
        empatesTimeAtual integer default 0;
        numJogos integer default 0;
        derrotasTimeAtual integer default 0;
        jogoAtual RECORD;
    BEGIN
      FOR time IN timesParticipantes LOOP
        FOR jogoAtual IN SELECT * FROM jogo WHERE campeonato = codCamp AND (time1 = time.sigla OR time2 = time.sigla) LOOP
            IF time.sigla = jogoAtual.time1 AND jogoAtual.gols1 > jogoAtual.gols2 THEN
                vitoriasTimeAtual := vitoriasTimeAtual + 1;
                pontosTimeAtual := pontosTimeAtual + 3;
                numJogos := numJogos + 1;
            ELSIF time.sigla = jogoAtual.time2 AND jogoAtual.gols1 < jogoAtual.gols2 THEN
                vitoriasTimeAtual := vitoriasTimeAtual + 1;
                pontosTimeAtual := pontosTimeAtual + 3;
                numJogos := numJogos + 1;
            ELSIF (time.sigla = jogoAtual.time1 OR time.sigla = jogoAtual.time2) AND  jogoAtual.gols1 = jogoAtual.gols2 THEN 
                pontosTimeAtual := pontosTimeAtual + 1;
                empatesTimeAtual := empatesTimeAtual + 1;
                numJogos := numJogos + 1;
            ELSE 
                numJogos := numJogos + 1;
                derrotasTimeAtual := derrotasTimeAtual + 1;
            END IF;
        END LOOP;
        RETURN QUERY SELECT time.nome, pontosTimeAtual, numJogos, vitoriasTimeAtual, empatesTimeAtual, derrotasTimeAtual;
        vitoriasTimeAtual :=0;
        pontosTimeAtual :=0;
        numJogos := 0;
        derrotasTimeAtual := 0;
        empatesTimeAtual := 0;
      END LOOP; 
      RETURN;
    END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION tabelaFinalClassificacao(codCamp text, posInicial integer, posFinal integer)
    RETURNS TABLE(clube TEXT, pontos integer, numjogos integer, vitorias integer, empates integer, derrotas integer)
    AS $$
    BEGIN
     RETURN QUERY SELECT * FROM computaTabela(codCamp) ORDER BY pontos DESC, vitorias DESC LIMIT posFinal-posInicial+1 OFFSET posInicial-1;
    END;
$$
LANGUAGE PLPGSQL;




SELECT * FROM tabelaFinalClassificacao('CAR20', 1, 4); 