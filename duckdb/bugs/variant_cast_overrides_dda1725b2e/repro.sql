.mode list
.nullvalue NULL
SET Calendar = 'gregorian';
SET TimeZone = 'Europe/Berlin';
select '1992-09-20 12:30:00.123456789+05:00'::TIMESTAMPTZ as t;
select '1992-09-20 12:30:00.123456789+05:00'::TIMESTAMPTZ::VARIANT as tv;
