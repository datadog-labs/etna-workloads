create type comptype as (r float8, i float8);
create domain dcomptype as comptype;
create table dcomptable (d1 dcomptype[]);
create rule silly as on delete to dcomptable do instead
  update dcomptable set d1[1].r = d1[1].r - 1, d1[1].i = d1[1].i + 1
    where d1[1].i > 0;
\d+ dcomptable
