select date_bin(
  interval '1 nanosecond',
  arrow_cast(9223372036854775807, 'Timestamp(Second, None)'),
  timestamp '1970-01-01 00:00:00'
);

select date_bin(
  interval '1 nanosecond',
  ts,
  timestamp '1970-01-01 00:00:00'
)
from (
  values (arrow_cast(9223372036854775807, 'Timestamp(Second, None)'))
) as t(ts);
