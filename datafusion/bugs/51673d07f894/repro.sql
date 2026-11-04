SELECT
  arrow_cast(TIMESTAMP '2024-01-01 00:00:00', 'Timestamp(Second, None)') =
    arrow_cast(TIMESTAMP '2024-01-01 00:00:00.123', 'Timestamp(Millisecond, None)') AS eq,
  arrow_cast(TIMESTAMP '2024-01-01 00:00:00', 'Timestamp(Second, None)') <
    arrow_cast(TIMESTAMP '2024-01-01 00:00:00.123', 'Timestamp(Millisecond, None)') AS lt;

SELECT
  arrow_cast(TIMESTAMP '2024-01-01 00:00:00.123', 'Timestamp(Millisecond, None)') -
    arrow_cast(TIMESTAMP '2024-01-01 00:00:00', 'Timestamp(Second, None)') AS diff;

SELECT arrow_typeof(ts), ts
FROM (
  SELECT arrow_cast(TIMESTAMP '2024-01-01 00:00:00', 'Timestamp(Second, None)') AS ts
  UNION ALL
  SELECT arrow_cast(TIMESTAMP '2024-01-01 00:00:00.123', 'Timestamp(Millisecond, None)') AS ts
)
ORDER BY ts;
