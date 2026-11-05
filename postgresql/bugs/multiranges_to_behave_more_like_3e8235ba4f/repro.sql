create type textrange1 as range(subtype=text, multirange_type_name=multitextrange1, collation="C");
create role regress_mr_owner;
alter type multitextrange1 owner to regress_mr_owner;
alter type textrange1 owner to regress_mr_owner;
set role regress_mr_owner;
revoke usage on type multitextrange1 from public;
revoke usage on type textrange1 from public;
\dT+ *textrange1*
reset role;
drop type textrange1;
drop role regress_mr_owner;
