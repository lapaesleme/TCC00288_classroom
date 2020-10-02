DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE if exists campeonato cascade;
CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer not null,
    CONSTRAINT campeonato_pk PRIMARY KEY
    (codigo)
);

DROP TABLE if exists time_ cascade;
CREATE TABLE time_ (
    sigla text NOT NULL,
    nome TEXT NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY
    (sigla)
);

DROP TABLE if exists jogo cascade;
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

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('1', 'Campeonato Brasileiro', 2020);

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('2', 'Campeonato Carioca', 2020);

INSERT INTO campeonato (codigo, nome, ano)
VALUES ('3', 'Campeonato Paulista', 2020);

INSERT INTO time_ (sigla, nome)
VALUES ('FLA', 'Flamengo');

INSERT INTO time_ (sigla, nome)
VALUES ('COR', 'Corinthias');

INSERT INTO time_ (sigla, nome)
VALUES ('BOT', 'Botafogo');

-- GANHOU: FLA
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 1, 'FLA', 'BOT', 3, 2, '2020-09-30');

-- EMPATOU
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 2, 'BOT', 'FLA', 1, 1, '2020-09-30');

-- GANHOU: FLA
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 3, 'FLA', 'COR', 1, 0, '2020-09-30');

-- GANHOU: COR 
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 4, 'COR', 'FLA', 2, 0, '2020-09-30');

-- GANHOU: COR
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 5, 'BOT', 'COR', 0, 3, '2020-09-30');

-- GANHOU: COR
INSERT INTO jogo (campeonato, numero, time1, time2, gols1, gols2, data_)
VALUES ('1', 6, 'COR', 'BOT', 3, 2, '2020-09-30');

CREATE OR REPLACE FUNCTION classification_championship(cod_campeonato text, pos_ini_rank integer, pos_final_rank integer) RETURNS TABLE(pos integer, sigla text, pontuacao integer) AS $$
DECLARE
    partida RECORD;
    i RECORD;
    position integer;
    qtd_linhas_rank integer;
BEGIN
    DROP TABLE if exists classification cascade;
    CREATE TABLE classification(
        pos integer,
        sigla text,
        pontuacao integer
    );

    FOR i IN SELECT DISTINCT time_.sigla FROM time_ INNER JOIN jogo ON time_.sigla = jogo.time1 OR time_.sigla = jogo.time2 LOOP
        INSERT INTO classification (sigla, pontuacao)
        VALUES (i.sigla, 0);
    END LOOP;
    
    FOR partida IN SELECT * FROM jogo WHERE campeonato = cod_campeonato LOOP
        IF partida.gols1 = partida.gols2 THEN
            UPDATE classification SET pontuacao = classification.pontuacao + 1 WHERE classification.sigla = partida.time1;
            UPDATE classification SET pontuacao = classification.pontuacao + 1 WHERE classification.sigla = partida.time2;
        ELSIF partida.gols1 > partida.gols2 THEN
            UPDATE classification SET pontuacao = classification.pontuacao + 3 WHERE classification.sigla = partida.time1;
        ELSIF partida.gols1 < partida.gols2 THEN
            UPDATE classification SET pontuacao = classification.pontuacao + 3 WHERE classification.sigla = partida.time2;
        END IF;
    END LOOP;

    position := 1;
    FOR i IN SELECT * FROM classification ORDER BY pontuacao DESC LOOP
        UPDATE classification SET pos = position WHERE classification.sigla = i.sigla;
        position := position + 1;
    END LOOP;
    
    IF (pos_final_rank - (pos_ini_rank - 1)) >= 0 THEN
        qtd_linhas_rank := pos_final_rank - (pos_ini_rank - 1);
    ELSE
        qtd_linhas_rank := 0;
    END IF;

    RETURN QUERY SELECT * FROM classification ORDER BY pontuacao DESC LIMIT qtd_linhas_rank OFFSET (pos_ini_rank - 1);
END
$$ LANGUAGE plpgsql;

SELECT * FROM classification_championship('1', 1, 3);