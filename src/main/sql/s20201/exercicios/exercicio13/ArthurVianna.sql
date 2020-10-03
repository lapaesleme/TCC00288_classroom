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

INSERT INTO campeonato
    VALUES('CB2020', 'Campeonato Brasileiro', 2020);

drop table if exists time_ cascade;
CREATE TABLE time_ (
sigla text NOT NULL,
nome TEXT NOT NULL,

CONSTRAINT time_pk PRIMARY KEY
(sigla));

INSERT INTO time_
    VALUES('VAS', 'Vasco da Gama');
INSERT INTO time_
    VALUES('FLA', 'Flamengo');
INSERT INTO time_
    VALUES('FLU', 'Fluminense');
INSERT INTO time_
    VALUES('BOT', 'Botafogo');
INSERT INTO time_
    VALUES('CAP', 'Atlético Paranaense');
INSERT INTO time_
    VALUES('CFC', 'Curitiba');
INSERT INTO time_
    VALUES('SAN', 'Santos');
INSERT INTO time_
    VALUES('SAO', 'São Paulo');
INSERT INTO time_
    VALUES('COR', 'Corinthians');
INSERT INTO time_
    VALUES('GRE', 'Grêmio');
INSERT INTO time_
    VALUES('FOR', 'Fortaleza');
INSERT INTO time_
    VALUES('CAM', 'Atlético Mineiro');
INSERT INTO time_
    VALUES('BRG', 'Bragantino');
INSERT INTO time_
    VALUES('BAH', 'Bahia');
INSERT INTO time_
    VALUES('AGO', 'Atlético Goianiense');
INSERT INTO time_
    VALUES('CEA', 'Ceará');
INSERT INTO time_
    VALUES('GOI', 'Goiás');
INSERT INTO time_
    VALUES('INT', 'Internacional');
INSERT INTO time_
    VALUES('PAL', 'Palmeiras');
INSERT INTO time_
    VALUES('SPT', 'Sport');

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
--rodada 10 do Brasileirão
INSERT INTO jogo
    VALUES('CB2020', 0, 'CAP', 'CFC', 1, 0, '2020-09-12');
INSERT INTO jogo
    VALUES('CB2020', 1, 'SAN', 'SAO', 2, 2, '2020-09-12');
INSERT INTO jogo
    VALUES('CB2020', 2, 'FLU', 'COR', 2, 1, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 3, 'GRE', 'FOR', 1, 1, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 4, 'CAM', 'BRG', 2, 1, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 5, 'BAH', 'AGO', 0, 1, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 6, 'CEA', 'FLA', 2, 0, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 7, 'GOI', 'INT', 1, 0, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 8, 'PAL', 'SPT', 2, 2, '2020-09-13');
INSERT INTO jogo
    VALUES('CB2020', 9, 'BOT', 'VAS', 2, 3, '2020-09-13');


CREATE OR REPLACE FUNCTION comp_tabela(cod_camp text, pos_inicial int, pos_final int) 
RETURNS TABLE(sigla text, pontos int, j int, v int, gols int) AS $$
DECLARE
    jogo RECORD;
    clube RECORD;
    class_clube RECORD;
BEGIN
    DROP TABLE IF EXISTS classificacao CASCADE;
    CREATE TEMPORARY TABLE classificacao(
        sigla text, --sigla do clube
        pontos int,
        j int, --qtd de jogos
        v int, --qtd de vitórias
        gols int,
        CONSTRAINT classificacao_PK PRIMARY KEY(sigla)
    );
    FOR clube IN (SELECT * FROM time_) LOOP

        INSERT INTO classificacao VALUES(clube.sigla, 0, 0, 0, 0);
        SELECT * INTO class_clube FROM classificacao AS c 
        WHERE c.sigla = clube.sigla;

        FOR jogo IN (SELECT * FROM jogo AS j WHERE j.campeonato = cod_camp AND 
        j.time1 = clube.sigla OR j.time2 = clube.sigla) LOOP
            class_clube.j = class_clube.j +1; --mais um jogo

            IF class_clube.sigla = jogo.time1 THEN --se o clube for o mandante
                class_clube.gols = class_clube.gols + jogo.gols1;
                IF jogo.gols1 > jogo.gols2 THEN --vitoria
                    class_clube.pontos = class_clube.pontos + 3;
                    class_clube.v = class_clube.v +1;
                ELSIF jogo.gols1 = jogo.gols2 THEN --empate
                    class_clube.pontos = class_clube.pontos + 1;
                END IF;

            ELSE -- se o clube for o visitante
                class_clube.gols = class_clube.gols + jogo.gols2;
                IF jogo.gols2 > jogo.gols1 THEN --vitoria
                    class_clube.pontos = class_clube.pontos + 3;
                    class_clube.v = class_clube.v +1;
                ELSIF jogo.gols2 = jogo.gols1 THEN --empate
                    class_clube.pontos = class_clube.pontos + 1;
                END IF;
            END IF;
            
            UPDATE classificacao SET 
            pontos = class_clube.pontos,
            j = class_clube.j,
            v = class_clube.v,
            gols = class_clube.gols
            WHERE classificacao.sigla = class_clube.sigla;
        END LOOP;
    END LOOP;
    --criterio de desempate é o número de vitórios
    RETURN QUERY (
    SELECT * FROM classificacao 
    ORDER BY pontos DESC, v DESC
    LIMIT pos_final OFFSET pos_inicial);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM comp_tabela('CB2020', 0, 20); --tabela completa
SELECT * FROM comp_tabela('CB2020', 0, 3); --3 primeiros
SELECT * FROM comp_tabela('CB2020', 17, 3); --3 últimos
