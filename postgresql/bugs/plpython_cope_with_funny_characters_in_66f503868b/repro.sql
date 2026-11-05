create extension plpython3u;
create function "Odd name #1"(a text) returns text as 'return a' language plpython3u;
select "Odd name #1"('hi');
