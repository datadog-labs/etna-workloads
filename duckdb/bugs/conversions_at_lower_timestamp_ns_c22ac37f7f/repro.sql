.mode list
.nullvalue NULL
SELECT epoch_ns(make_timestamp_ns(-9223372036854775807::BIGINT - 1)),
       epoch_ns(make_timestamp_ns(-9223372036854775806::BIGINT));
SELECT CAST(make_timestamp_ns(-9223372036854775807::BIGINT - 1) AS VARCHAR),
       CAST(make_timestamp_ns(-9223372036854775806::BIGINT) AS VARCHAR);
