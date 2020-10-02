DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    nome character varying NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk
               PRIMARY KEY (codigo)
);


INSERT INTO produto VALUES(0, 'Kinder Ovo', 50);
INSERT INTO produto VALUES(1, 'Ouro', 500);
INSERT INTO produto VALUES(2, 'Arroz', 1000);

-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION atualizar_preco()
RETURNS VOID AS $$
    DECLARE
        novo_preco REAL;
    
        curs CURSOR FOR
                SELECT codigo, preco
                FROM produto;
    
    BEGIN
        FOR produto_a_mudar IN curs LOOP
            novo_preco = produto_a_mudar.preco * 1.1;
            UPDATE produto
            SET preco = novo_preco
            WHERE produto.codigo = produto_a_mudar.codigo;
        END LOOP;

    END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------

SELECT * from produto;

SELECT atualizar_preco();

SELECT * from produto;