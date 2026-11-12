.mode list
.nullvalue NULL
select try_cast('hello world'::variant as int) + 1;
select try_cast('hello world'::variant as STRUCT(a varchar, b boolean));
select try_cast({'a': true, 'b': 'foo'}::variant as STRUCT(a varchar, b boolean));
select try_cast({'c': true, 'd': 'foo'}::variant as STRUCT(a varchar, b boolean));
select try_cast('hello world'::variant as INTEGER[]);
with cte as (
	from ( values
		('test'::VARIANT),
		(null::VARIANT),
		(42::VARIANT)
	) t(a)
)
select try_cast(a as INT) from cte;
with cte as (
	from ( values
		('test'::VARIANT),
		(null::VARIANT),
		(42::VARIANT)
	) t(a)
)
select try_cast(a as STRUCT(a varchar, b boolean)) from cte;
with cte as (
	from ( values
		('test'::VARIANT),
		(null::VARIANT),
		(42::VARIANT)
	) t(a)
)
select try_cast(a as BOOLEAN[]) from cte;
with cte as (
	from ( values
		('test'::VARIANT),
		(null::VARIANT),
		(42::VARIANT)
	) t(a)
)
select try_cast(a as UNION(a integer, b decimal)) from cte;
select try_cast(json('["1","x"]')::VARIANT as INTEGER[]);
select try_cast(json('["1","x"]')::VARIANT as INTEGER[2]);
