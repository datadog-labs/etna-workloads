set plan_cache_mode = force_generic_plan;
create table part_abc (a int, b text, c bool) partition by list (a);
create table part_abc_1 partition of part_abc for values in (1);
create table part_abc_2 partition of part_abc for values in (2);
prepare u as update part_abc set b = $2 where a = $1 returning *;
explain (verbose, costs off) execute u (1, 'd');
explain (verbose, costs off) execute u (2, 'a');
explain (verbose, costs off) execute u (3, 'a');
