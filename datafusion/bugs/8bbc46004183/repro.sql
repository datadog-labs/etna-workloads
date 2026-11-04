select
  arrow_typeof(nanvl(arrow_cast(1.0, 'Float16'), arrow_cast(2.0, 'Float32'))),
  arrow_typeof(nanvl(arrow_cast(1.0, 'Float16'), arrow_cast(2.0, 'Float64'))),
  arrow_typeof(nanvl(1, 2)),
  arrow_typeof(nanvl(1, arrow_cast(2.0, 'Float32'))),
  arrow_typeof(nanvl(null, null));
select
  nanvl(16777217, 1) = nanvl(arrow_cast(16777217, 'Float64'), 1.0) as a,
  nanvl(16777217, arrow_cast(1.0, 'Float32')) = nanvl(arrow_cast(16777217, 'Float64'), 1.0) as b;
select nanvl(16777217, 1) as v;
