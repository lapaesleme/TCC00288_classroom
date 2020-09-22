DROP TABLE IF EXISTS matriz CASCADE;

CREATE TABLE matriz(
    id int NOT NULL,
    matriz_elem float[][],
    
    CONSTRAINT matriz_PK PRIMARY KEY (id)
);
-- Correto
INSERT INTO matriz(id, matriz_elem) 
    VALUES (1,
            '{{1.0,2.0,3.0}, {4.0,5.0,6.0}, {7.0,8.0,9.0}, {10.0,11.0,12.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (2,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}, {7.0,8.0,9.0,12.0}}');
-- Exception
INSERT INTO matriz(id, matriz_elem) 
    VALUES (3,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}}');

INSERT INTO matriz(id, matriz_elem) 
    VALUES (4,
            '{{1.0,2.0,3.0,10.0}, {4.0,5.0,6.0,11.0}, {7.0,8.0,9.0,12.0}}');

CREATE OR REPLACE FUNCTION excluiLiCol(m float[][], i int, j int) RETURNS float[][] AS $$
DECLARE
    linhas_m int := array_length(m, 1); --numero de linhas de m
    colunas_m int := array_length(m, 2); --numero de colunas de m
    temp float[][]; --matriz temporaria onde construiremos a nova matriz
    linha_temp float[]; --linha que será usada para construir a matriz temporária
BEGIN
    IF i > linhas_m THEN
        RAISE EXCEPTION 'A matriz escolhida não possui linha %!', i;
    ELSIF j > colunas_m THEN
        RAISE EXCEPTION 'A matriz escolhida não possui coluna %!', j;
    END IF;

    FOR linha IN 1..linhas_m LOOP
        IF linha != i THEN
            FOR coluna IN 1..colunas_m LOOP
                IF coluna != j THEN
                    --adiciona elemento a linha
                    linha_temp := array_append(linha_temp, m[linha][coluna]);
                END IF;
            END LOOP;
            --adiciona linha a matriz temp
            temp := array_cat(temp, array[linha_temp]);
            --esvazia a linha
            linha_temp := '{}';
        END IF;
    END LOOP;
    RAISE NOTICE 'Matriz tem: %', temp;
    m := temp;
    RETURN m;
END;
$$ LANGUAGE plpgsql;

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 1),1,1);

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 1),1,2);

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 2),2,1);

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 3),2,1);

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 4),3,2);

--Exceptions
SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 4),5,1);

SELECT * from excluiLiCol(
    (SELECT matriz_elem FROM matriz WHERE id = 4),1,6);
