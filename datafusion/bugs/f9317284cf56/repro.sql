select date_bin(interval '1 month', to_timestamp_millis(-1040292460), timestamp '1984-01-07 00:00:00');
select date_bin(interval '1 month', c, timestamp '1984-01-07 00:00:00') from values (to_timestamp_millis(-1040292460)) t(c);
