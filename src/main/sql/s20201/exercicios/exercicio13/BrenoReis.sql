DROP TABLE IF EXISTS campeonato CASCADE;
CREATE TABLE campeonato 
(
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer not null,
    CONSTRAINT campeonato_pk PRIMARY KEY (codigo)
);

DROP TABLE IF EXISTS time_ CASCADE;
CREATE TABLE time_ 
(
    sigla text NOT NULL,
    nome TEXT NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY (sigla)
);

DROP TABLE IF EXISTS jogo CASCADE;
CREATE TABLE jogo 
(
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

INSERT INTO campeonato VALUES ('A', 'A', 2000);
INSERT INTO time_ VALUES ('A','AAA');
INSERT INTO time_ VALUES ('B','BBB');
INSERT INTO time_ VALUES ('C','CCC');
INSERT INTO time_ VALUES ('D','DDD');
INSERT INTO time_ VALUES ('E','EEE');
INSERT INTO time_ VALUES ('F','FFF');
INSERT INTO time_ VALUES ('G','GGG');
INSERT INTO jogo VALUES ('A',1,'A','B',1,1,'2000-01-10');
INSERT INTO jogo VALUES ('A',2,'A','C',3,2,'2000-01-11');
INSERT INTO jogo VALUES ('A',3,'A','D',1,0,'2000-01-12');
INSERT INTO jogo VALUES ('A',4,'A','E',1,0,'2000-01-13');
INSERT INTO jogo VALUES ('A',5,'A','F',2,4,'2000-01-14');
INSERT INTO jogo VALUES ('A',6,'B','C',1,2,'2000-01-15');
INSERT INTO jogo VALUES ('A',7,'B','D',1,1,'2000-01-16');
INSERT INTO jogo VALUES ('A',8,'B','E',3,2,'2000-01-17');
INSERT INTO jogo VALUES ('A',9,'B','F',3,0,'2000-01-18');
INSERT INTO jogo VALUES ('A',10,'C','D',1,3,'2000-01-19');
INSERT INTO jogo VALUES ('A',11,'C','E',2,2,'2000-01-20');
INSERT INTO jogo VALUES ('A',12,'C','F',1,1,'2000-01-21');
INSERT INTO jogo VALUES ('A',13,'D','E',3,4,'2000-01-22');
INSERT INTO jogo VALUES ('A',14,'D','F',5,0,'2000-01-23');
INSERT INTO jogo VALUES ('A',15,'E','F',1,3,'2000-01-24');
INSERT INTO jogo VALUES ('A',16,'B','A',1,2,'2000-01-25');

DROP FUNCTION IF EXISTS classificacaoAux(codigoCampeonato text);
CREATE OR REPLACE FUNCTION classificacaoAux(codigoCampeonato text)
    RETURNS TABLE(nomeTime TEXT, pontos integer, vitorias integer, empates integer) AS $$
    DECLARE
        tuplaCampeonato RECORD;
        tuplaTimesCampeonato RECORD;
        contVitorias integer := 0;
        contEmpates integer := 0;
        somaPontos integer := 0;
    BEGIN
        FOR tuplaTimesCampeonato IN SELECT time_.sigla FROM time_ JOIN jogo ON (time_.sigla = jogo.time1) UNION SELECT time_.sigla FROM time_ JOIN jogo ON (time_.sigla = jogo.time2) LOOP
            FOR tuplaCampeonato IN SELECT time1, time2, gols1, gols2 FROM jogo JOIN campeonato ON(jogo.campeonato = campeonato.codigo) WHERE jogo.campeonato = codigoCampeonato LOOP
                IF tuplaCampeonato.gols1 = tuplaCampeonato.gols2 AND (tuplaCampeonato.time1 = tuplaTimesCampeonato.sigla OR tuplaCampeonato.time2 = tuplaTimesCampeonato.sigla) THEN
                    contEmpates := contEmpates + 1;
                    somaPontos := somaPontos + 1;
                ELSIF tuplaCampeonato.gols1 > tuplaCampeonato.gols2 AND tuplaCampeonato.time1 = tuplaTimesCampeonato.sigla THEN
                    contVitorias := contVitorias + 1;
                    somaPontos := somaPontos + 3;
                ELSIF tuplaCampeonato.gols1 < tuplaCampeonato.gols2 AND tuplaCampeonato.time2 = tuplaTimesCampeonato.sigla THEN
                    contVitorias := contVitorias + 1;
                    somaPontos := somaPontos + 3;
                END IF;                
            END LOOP;
            RETURN QUERY SELECT tuplaTimesCampeonato.sigla, somaPontos, contVitorias, contEmpates;
            somaPontos := 0;
            contVitorias := 0;
            contEmpates := 0;
        END LOOP;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;

DROP FUNCTION IF EXISTS classificacao(codigoCampeonato text, ranqueInicial integer, ranqueFinal integer);
CREATE OR REPLACE FUNCTION classificacao(codigoCampeonato text, ranqueInicial integer, ranqueFinal integer)
    RETURNS TABLE(nomeTime TEXT, pontos integer, vitorias integer, empates integer) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM classificacaoAux(codigoCampeonato) ORDER BY pontos DESC LIMIT ranqueFinal-ranqueInicial+1 OFFSET ranqueInicial-1; 
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM classificacao('A', 1, 4);
