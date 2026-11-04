select date_bin(
  interval '1 nanosecond',
  arrow_cast(9223372036854775807, 'Timestamp(Nanosecond, None)'),
  arrow_cast(-9223372036854775808, 'Timestamp(Nanosecond, None)')
);
