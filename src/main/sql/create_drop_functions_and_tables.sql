DO $$
DECLARE
    _sql text;
BEGIN
    SELECT
    INTO _sql
          string_agg(format('DROP %s %s CASCADE;'
                          , CASE prokind
                              WHEN 'f' THEN 'FUNCTION'
                              WHEN 'a' THEN 'AGGREGATE'
                              WHEN 'p' THEN 'PROCEDURE'
                              WHEN 'w' THEN 'FUNCTION'
                            END
                          , oid::regprocedure)
                   , E'\n')
    FROM   pg_proc
    WHERE  pronamespace = 'public'::regnamespace;

    IF _sql IS NOT NULL THEN
        RAISE NOTICE E'\n\n%', _sql;
        EXECUTE _sql;
    END IF;
END$$;



CREATE OR REPLACE FUNCTION drop_functions() RETURNS void as $do$
DECLARE
   _sql text;
BEGIN
    SELECT
    INTO _sql
        string_agg(format('DROP %s %s CASCADE;'
                    , CASE prokind
                        WHEN 'f' THEN 'FUNCTION'
                        WHEN 'a' THEN 'AGGREGATE'
                        WHEN 'p' THEN 'PROCEDURE'
                        WHEN 'w' THEN 'FUNCTION'
                        -- ELSE NULL
                      END
                    , oid::regprocedure)
            , E'\n')
    FROM   pg_proc
    WHERE  pronamespace = 'public'::regnamespace
    AND not array[proname] <@ '{"drop_functions","drop_tables"}';

    IF _sql IS NOT NULL THEN
        RAISE NOTICE E'\n\n%', _sql;
        EXECUTE _sql;
    END IF;
END$do$ language plpgsql;



--SELECT
--	n.nspname as SchemaName
--	,c.relname as RelationName
--	,CASE c.relkind
--	WHEN 'r' THEN 'table'
--	WHEN 'v' THEN 'view'
--	WHEN 'i' THEN 'index'
--	WHEN 'S' THEN 'sequence'
--	WHEN 's' THEN 'special'
--	END as RelationType
--	,pg_catalog.pg_get_userbyid(c.relowner) as RelationOwner
--	,pg_size_pretty(pg_relation_size(n.nspname ||'.'|| c.relname)) as RelationSize
--FROM pg_catalog.pg_class c
--LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
--WHERE c.relkind IN ('r','s')
--AND  (n.nspname !~ '^pg_toast' and nspname like 'pg_temp%')


CREATE OR REPLACE FUNCTION drop_tables() RETURNS void as $do$
DECLARE
    _sql text;
BEGIN
    SELECT
    INTO _sql
        string_agg(format('DROP TABLE IF EXISTS %s CASCADE;', c.relname), E'\n')
    FROM pg_catalog.pg_class c
    LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relkind IN ('r','s') AND  (n.nspname = 'public' OR (n.nspname !~ '^pg_toast' AND nspname LIKE 'pg_temp%'));

    --SELECT
    --INTO _sql
    --       string_agg(format('DROP TABLE IF EXISTS %s CASCADE;', t.table_name), E'\n')
    --FROM   information_schema.tables t
    --WHERE  t.table_schema = 'public'::information_schema.sql_identifier;

    IF _sql IS NOT NULL THEN
        RAISE NOTICE E'\n\n%', _sql;
        EXECUTE _sql;
    END IF;
END$do$ language plpgsql;



DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;