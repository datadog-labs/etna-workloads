SELECT uuid_extract_timestamp(uuidv7()) > TIMESTAMP '2020-01-01' AS ok, uuid_extract_timestamp(uuidv7()) < TIMESTAMP '2100-01-01' AS ok2;
