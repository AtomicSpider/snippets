-- Data Types
https://www.postgresql.org/docs/14/datatype.html

--Aggregate Functions
https://www.postgresql.org/docs/14/functions-aggregate.html

date in query-> DATE 'str date'

---- PSQL
psql --help

psql -h <host> -p <port>-d <dbname> -U <username>

-- Within psql ->
help > help
\h for help with SQL commands
\? for help with psql commands
\g or terminate with semicolon to execute query
\q to quit

\l > list databases
\timing [ON|OFF] --Enable disable psql cmd timimg

CREATE DATABASE <name>;
DROP DATABASE <name>;

\c <database_name> --switch to database

CREATE TABLE <table_name> (
	<col_name> <d_type> <constraints>
);

DROP TABLE <table_name>;

\d --List tables
\d <table_name> --Describe Table

INSERT INTO person(
	c1,
	c2,
	c3)
VALUES(v1, v2, v3);

\i <filename.sql> --Executes commands from file

SELECT <col1>, <col2> FROM <table_name>;

ORDER BY <col1>, <col2>
DESC
ASC
LIMIT <n>
OFFSET <n>
IN <user_array_as_tuple>
BETWEEN <v1> AND <v2>
LIKE '%.com%' --% is used for any and any lenth char
LIKE '___o@%' --_ is used to specify valid char (pattern exactly 3 chars then o then @ and then any chars)
iLike -- Same as like but ignores case
GROUP BY <col>, <col2>  -- group by multiple cols will act as and
GROUP BY <col>, <col2> HAVING <fn> --Extra filter after grouping
-- select country_of_birth, count(country_of_birth) from person group by country_of_birth having count(*)>15 order by country_of_birth;

DISTINCT

WHERE <conditions>
AND/OR -- cond1 AND (cond2 OR cond3)
=, <, >, >=, <=, <> -- Conditional operators

-- Functions
COUNT
MIN
MAX
AVG
ROUND(val, scale)
SUM

-- Airthmatic
+ - * / ^ ! %

--Alias
<operation> AS

COALESCE(val1, val2, val3, val4) --return the first not null val COALESCE(email, 'ERROR: Email not available')
NULLIF(v1, v2) --if v1==v2 -> null, else v1

-- Time
NOW() -- current timestamp
NOW()::DATE -- :: used for casting
NOW()::TIME
INTERVAL '1 YEAR' -- now()::date - interval '5 months'
EXTRACT -- EXTRACT(YEAR FROM NOW)
AGE  -- select first_name, gender, EXTRACT(YEAR from AGE(now(), date_of_birth)) from person;

ALTER TABLE table_name
RENAME COLUMN column_name TO new_column_name;

ALTER TABLE person DROP constraint P_KEY
ALTER TABLE person ADD PRIMARY KEY
ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE(email)
ALTER TABLE person ADD UNIQUE(email)
ALTER TABLE person ADD CONSTRAINT gender_option CHECK (gender='Female' OR gender='Male')

DELETE FROM person WHERE <condition>
UPDATE person SET <col1>=<val1>, <col1>=<val1> WHERE <condition>

INSERT INTO ..... ON CONFLICT (id) DO NOTHING --Supress Error, only works on unique column
INSERT INTO ..... ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email --Supress Error, only works on unique column

--Foreign keys
car_id BIGINT REFRENCES car(id) UNIQUE(car_id)

--Joins
--Inner join -> Common
SELECT * FROM person JOIN car ON person.car_id=car.id; 
-- Left Join -> all records from left table
-- Right Join -> all records from right table
-- Full Join -> all records from all table

--export
\copy (SELECT ...) TO data.csv DELIMITER ',' CSV HEADER;

--sequence
SELECT nextval('person_id_seq'::regclass)
ALTER SEQUENCE person_id_seq RESTART WITH 1;

--extensions
select * from pg_available_extensions;
CREATE EXTENSION IF NOT EXISTS 'extension-name';
select uuid_generate_v4();

---- get all database connections
SELECT
	pg_terminate_backend(pg_stat_activity.pid)
FROM
	pg_stat_activity
WHERE
	pg_stat_activity.datname = 'database_name'
	AND pid <> pg_backend_pid();


---- Get nested json example

select id, config -> 'submissionList' -> json_object_keys(config -> 'submissionList') -> 'workbench_args' -> 'user_id' as uid, config -> 'submissionList' -> json_object_keys(config -> 'submissionList') -> 'workbench_args' -> 'project_id' as pid, config -> 'submissionList' -> json_object_keys(config -> 'submissionList') -> 'display_name' as toolbox from workflow where id = ANY(ARRAY[2538,2273,2267,2255,2243,1899,1894,1885,1876,1861,1857]);
