repro.sql: table with index on (b, b+c), insert zeroblob(8) into b. The arithmetic b+c
(computeNumericType without ExpandBlob) truncates the zeroblob. Clean shell returns
`1|X'0000000000000000'|8|3`; buggy shell returns a truncated/changed blob and length.
