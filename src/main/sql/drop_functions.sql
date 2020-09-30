CREATE OR REPLACE FUNCTION drop_functions() RETURNS void as $do$
DECLARE
   _sql text;
   _schema regnamespace = 'public'::regnamespace;
   _function_name text = 'drop_functions';

BEGIN
   SELECT INTO _sql
          string_agg(format('DROP %s %s CASCADE;'
                          , CASE prokind
                              WHEN 'f' THEN 'FUNCTION'
                              WHEN 'a' THEN 'AGGREGATE'
                              WHEN 'p' THEN 'PROCEDURE'
                              WHEN 'w' THEN 'FUNCTION'  -- window function (rarely applicable)
                              -- ELSE NULL              -- not possible in pg 11
                            END
                          , oid::regprocedure)
                   , E'\n')
   FROM   pg_proc
   WHERE  pronamespace = _schema  -- schema name here!
   AND cast(oid::regprocedure as text) NOT LIKE _function_name || '%'::varchar
   -- AND    prokind = ANY ('{f,a,p,w}')         -- optionally filter kinds
   ;

   IF _sql IS NOT NULL THEN
      RAISE NOTICE E'\n\n%', _sql;  -- debug / check first
      EXECUTE _sql;            -- uncomment payload once you are sure
   END IF;
END
$do$ language plpgsql;


DO $$ BEGIN
    PERFORM drop_functions();
END $$;


select * from pg_proc;



--select oid::regprocedure from pg_proc where cast(oid::regprocedure as text)  not LIKE 'drop_functions%';