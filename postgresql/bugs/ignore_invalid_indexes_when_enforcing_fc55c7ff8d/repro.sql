create table parted_inval_tab (a int) partition by range (a);
create index parted_inval_idx on parted_inval_tab (a);
create table parted_inval_tab_1 (a int) partition by range (a);
create table parted_inval_tab_1_1 partition of parted_inval_tab_1 for values from (0) to (10);
create table parted_inval_tab_1_2 partition of parted_inval_tab_1 for values from (10) to (20);
create index parted_inval_ixd_1 on only parted_inval_tab_1 (a);
alter table parted_inval_tab attach partition parted_inval_tab_1 for values from (1) to (100);
select indexrelid::regclass, indisvalid, indrelid::regclass, inhparent::regclass
  from pg_index idx left join pg_inherits inh on (idx.indexrelid = inh.inhrelid)
  where indexrelid::regclass::text like 'parted_inval%'
  order by indexrelid::regclass::text collate "C";
