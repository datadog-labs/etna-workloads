select uuid_extract_timestamp(uuidv7(interval '3000 years')) > '2900-01-01' as far_future;
select uuid_extract_timestamp(uuidv7(interval '300 years')) > '2300-01-01' as future300;
