create type textrange as range (subtype=text, collation="C");
select unnest(textmultirange(textrange('\\\\', repeat('a', 200)), textrange('c', 'd')));
select textmultirange(textrange('\\\\', repeat('a', 200)), textrange('c', 'd'));
