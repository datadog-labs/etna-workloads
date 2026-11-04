SELECT arrow_typeof(round(arrow_cast(9007199254740993, 'Int64'))), round(arrow_cast(9007199254740993, 'Int64'));
SELECT arrow_typeof(round(arrow_cast(9007199254740993, 'Int64'), 2)), round(arrow_cast(9007199254740993, 'Int64'), 2);
SELECT arrow_typeof(round(arrow_cast(18446744073709551615, 'UInt64'))), round(arrow_cast(18446744073709551615, 'UInt64'));
SELECT round(arrow_cast(9223372036854775807, 'Int64'), -1);
