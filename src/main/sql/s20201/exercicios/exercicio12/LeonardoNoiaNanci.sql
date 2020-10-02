DROP TABLE IF EXISTS produto CASCADE;

CREATE TABLE produto (
    codigo integer NOT NULL,
    categoria character NOT NULL,
    preco real NOT NULL,
    CONSTRAINT produto_pk
               PRIMARY KEY (codigo)
);


INSERT INTO produto VALUES(0, 'A', 50);
INSERT INTO produto VALUES(1, 'B', 500);
INSERT INTO produto VALUES(2, 'C', 1000);

-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION atualizar_preco()
RETURNS VOID AS $$
    DECLARE
        novo_preco REAL;
        porcentagem REAL;
	
        curs CURSOR FOR
            SELECT *
            FROM produto;
	
    BEGIN
        FOR produto_a_mudar IN curs LOOP
		
            IF produto_a_mudar.categoria = 'A' THEN
                porcentagem = 1.05;
            ELSIF produto_a_mudar.categoria = 'B' THEN
                porcentagem = 1.1;
            ELSIF produto_a_mudar.categoria = 'C' THEN
                porcentagem = 1.15;
            END IF;
            novo_preco = produto_a_mudar.preco * porcentagem;
			
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