repro.go is the upstream issue47896 test (generic Repository/Collection/Mapper using database/sql) plus an empty main.
The injection removes the "reuse existing global dictionary Name" check in the unified IR reader, so a dictionary symbol gets multiple Name nodes.
go-clean: builds and runs, exit 0, no output.
go-buggy: compile fails with "symbol ...dict.X[...] redeclared" errors, first in stdlib packages that use generics (internal/bytealg, unicode/utf8, sync/atomic, ...). The order of the error blocks varies, because packages compile in parallel.
