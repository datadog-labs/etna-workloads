SELECT date_bin('30 minutes'::interval, timestamp '2024-02-01 15:00:00', timestamp '2024-02-01 17:00:00');
select date_bin('200000000 days'::interval, '2024-02-01'::timestamp, '2024-01-01'::timestamp);
