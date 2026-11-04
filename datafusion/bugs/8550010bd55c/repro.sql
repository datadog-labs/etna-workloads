select encode(arrow_cast(column1, 'LargeBinary'), 'hex') as e from values ('a'), ('b') order by e;
select arrow_cast(decode(arrow_cast(column1, 'LargeBinary'), 'hex'), 'Utf8') as d from values ('6162'), ('63') order by d;
