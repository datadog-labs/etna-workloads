create type rngfunc2 as (a integer, b text);
select *, row_to_json(u) from unnest(array[(1,'foo')::rngfunc2, null::rngfunc2]) u;
select *, row_to_json(u) from unnest(array[null::rngfunc2, null::rngfunc2]) u;
