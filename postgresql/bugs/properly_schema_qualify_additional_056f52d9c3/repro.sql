create schema s1;
create text search dictionary s1.d (template=simple);
drop schema s1 cascade;
