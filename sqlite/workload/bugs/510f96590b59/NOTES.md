repro.sql: table with INTEGER PRIMARY KEY and a BEFORE UPDATE trigger, then `UPDATE tA SET a='abc'`.
Clean shell: "datatype mismatch" error. Buggy shell: missing OP_MustBeInt, so the assert fails / wrong result.
