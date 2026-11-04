select atan2(1, 2), atan2(1, 1000000) = atan2(1.0, 1000000.0),
  arrow_typeof(atan2(1, 1)), arrow_typeof(atan2(null, 64)),
  arrow_typeof(atan2(arrow_cast(1.0, 'Float32'), arrow_cast(1.0, 'Float64')));
