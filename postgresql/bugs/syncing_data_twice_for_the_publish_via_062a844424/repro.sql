create table p(a int) partition by range(a);
create table c partition of p for values from (0) to (10);
create publication pa for table p with (publish_via_partition_root);
create publication pb for table c;
create subscription s connection 'dbname=postgres' publication pa, pb with (connect=true, enabled=false, create_slot=false, slot_name=NONE);
select srrelid::regclass from pg_subscription_rel order by 1;
