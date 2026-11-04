CREATE TABLE t AS SELECT arrow_cast(1,'UInt32') AS u32, arrow_cast(1,'Int32') AS i32, arrow_cast(1,'UInt16') AS u16, arrow_cast(1,'Int8') AS i8, arrow_cast(1,'UInt64') AS u64, arrow_cast(1,'Int64') AS i64;
SELECT arrow_typeof(u32+i32), arrow_typeof(u16+i8), arrow_typeof(u64+i64), arrow_typeof(u64*i8), arrow_typeof(u32-i8) FROM t;
SELECT u32+i32, u16-i8, u64/i64, u64*i8 FROM t;
