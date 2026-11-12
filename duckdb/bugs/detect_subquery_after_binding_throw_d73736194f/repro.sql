CREATE MACRO my_macro() AS (SELECT 1);
CREATE TABLE unit (
    total_profit INTEGER GENERATED ALWAYS AS(my_macro()) VIRTUAL,
    word VARCHAR
);
