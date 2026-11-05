CREATE DATABASE regression_invalid;
UPDATE pg_database SET datconnlimit = -2 WHERE datname = 'regression_invalid';
CREATE DATABASE regression_invalid_template TEMPLATE regression_invalid;
SELECT count(*) FROM pg_database WHERE datname = 'regression_invalid_template';
\c regression_invalid
\c postgres
DROP DATABASE IF EXISTS regression_invalid_template;
DROP DATABASE regression_invalid;
