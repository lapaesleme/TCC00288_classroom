DROP TABLE IF EXISTS time_ CASCADE;

DROP TABLE IF EXISTS campeonato CASCADE;

DROP TABLE IF EXISTS jogo CASCADE;


DO $$ BEGIN
    PERFORM drop_functions();
END $$;


CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome text NOT NULL,
    ano integer NOT NULL,
    CONSTRAINT campeonatopk PRIMARY KEY (codigo)
);

CREATE TABLE time_ (
    sigla text NOT NULL,
    nome text NOT NULL,
    CONSTRAINT timepk PRIMARY KEY (sigla)
);

CREATE TABLE jogo (
    campeonato text NOT NULL,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer NOT NULL,
    gols2 integer NOT NULL,
    data_ date NOT NULL,
    CONSTRAINT jogopk PRIMARY KEY (campeonato, numero),
    CONSTRAINT jogocampeonatofk FOREIGN KEY (campeonato) REFERENCES campeonato (codigo),
    CONSTRAINT jogotimefk1 FOREIGN KEY (time1) REFERENCES time_ (sigla),
    CONSTRAINT jogotimefk2 FOREIGN KEY (time2) REFERENCES time_ (sigla)
);

INSERT INTO campeonato
    VALUES ('BR-20', 'Campeonato Brasileiro 2020', 2020);

INSERT INTO time_
    VALUES ('FLA', 'Flamengo');

INSERT INTO time_
    VALUES ('VAS', 'Vasco');

INSERT INTO time_
    VALUES ('FLU', 'Fluminense');

INSERT INTO time_
    VALUES ('BOT', 'Botafogo');

INSERT INTO time_
    VALUES ('COR', 'Corinthians');

INSERT INTO time_
    VALUES ('SPO', 'São Paulo');

INSERT INTO time_
    VALUES ('PAL', 'Palmeiras');

INSERT INTO time_
    VALUES ('SAN', 'Santos');

INSERT INTO jogo
    VALUES ('BR-20', 1, 'FLA', 'VAS', 6, 0, '08-2-2020');

INSERT INTO jogo
    VALUES ('BR-20', 2, 'SPO', 'FLU', 2, 2, '09-2-2020');


INSERT INTO jogo
    VALUES ('BR-20', 3, 'BOT', 'COR', 0, 2, '10-2-2020');


INSERT INTO jogo
    VALUES ('BR-20', 4, 'FLA', 'FLU', 3, 0, '11-2-2020');


INSERT INTO jogo
    VALUES ('BR-20', 5, 'SPO', 'VAS', 4, 1, '12-2-2020');


INSERT INTO jogo
    VALUES ('BR-20', 6, 'BOT', 'SAN', 2, 2, '13-2-2020');
    

DROP TABLE IF EXISTS classificacaocampeonato;
    CREATE TABLE classificacaocampeonato (
        equipe text,
        pontos int,
        v int
    );

CREATE OR REPLACE FUNCTION classificacao(codigo text, inicial int, final int)
    RETURNS TABLE (
        NOME_DO_TIME text,
        PTS int,
        VITORIAS int
    )
    AS $$
DECLARE
    curs1 CURSOR FOR
        SELECT
            *
        FROM
            jogo
        WHERE
            jogo.campeonato = codigo;
    t_row record;
    nome1 text;
    nome2 text;
    pts_aux int;
    vit_aux int;
BEGIN
    
    OPEN curs1;
    LOOP
        FETCH curs1 INTO t_row;
        EXIT WHEN NOT FOUND;
        SELECT time_.nome FROM time_ WHERE sigla = t_row.time1 INTO nome1;
        SELECT time_.nome FROM time_ WHERE sigla = t_row.time2 INTO nome2;
        IF nome1 NOT IN (SELECT equipe FROM classificacaocampeonato) THEN INSERT INTO classificacaocampeonato (equipe, pontos, v) VALUES (nome1, 0, 0);
        END IF;
        IF nome2 NOT IN (SELECT equipe FROM classificacaocampeonato) THEN INSERT INTO classificacaocampeonato (equipe, pontos, v) VALUES (nome2, 0, 0);
        END IF;
        IF t_row.gols1 = t_row.gols2 THEN
            SELECT pontos FROM classificacaocampeonato WHERE equipe = nome1 OR equipe = nome2 INTO pts_aux;
            pts_aux := pts_aux + 1;
            UPDATE classificacaocampeonato SET pontos = pts_aux WHERE equipe = nome1 OR equipe = nome2;
        ELSIF t_row.gols1 > t_row.gols2 THEN
            SELECT INTO pts_aux, vit_aux  pontos, v FROM classificacaocampeonato WHERE equipe = nome1;
            pts_aux := pts_aux + 3;
            vit_aux := vit_aux + 1;
            UPDATE classificacaocampeonato  SET v = vit_aux, pontos = pts_aux WHERE equipe = nome1;
        ELSE
            SELECT INTO pts_aux, vit_aux  pontos, v FROM classificacaocampeonato WHERE equipe = nome2;
            pts_aux := pts_aux + 3;
            vit_aux := vit_aux + 1;
            UPDATE classificacaocampeonato SET v = vit_aux, pontos = pts_aux WHERE equipe = nome2;
        END IF;
    END LOOP;
    CLOSE curs1;
    RETURN QUERY
    SELECT
        equipe, pontos, v
    FROM
        classificacaocampeonato
    ORDER BY pontos DESC, v DESC
    LIMIT final - inicial + 1 OFFSET inicial - 1;
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM
   classificacao('BR-20',1,8);