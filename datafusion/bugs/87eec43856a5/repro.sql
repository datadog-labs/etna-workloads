create table test as select struct(1 as substruct) as struct_field;
select * from test as test1, test as test2 where test1.struct_field['substruct'] = test2.struct_field['substruct'];
drop table test;
create table test as select struct(struct(1 as subsubstruct) as substruct) as struct_field;
select * from test as test1, test as test2 where test1.struct_field.substruct['subsubstruct'] = test2.struct_field.substruct['subsubstruct'];
select * from test AS test1, test AS test2 where test1.struct_field['substruct']['subsubstruct'] = test2.struct_field['substruct']['subsubstruct'];
