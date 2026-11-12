.mode list
.nullvalue NULL
create table integers(i integer);
unpivot integers on columns(* exclude (i));
