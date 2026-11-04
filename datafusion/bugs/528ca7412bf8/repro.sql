select date_bin(
  interval '3 nanoseconds',
  arrow_cast(-9223372036854775808, 'Timestamp(Nanosecond, None)')
);
