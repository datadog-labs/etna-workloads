With trusted_schema=OFF, a view calling json_extract() is queried. The injection sets the
SQLITE_INNOCUOUS bit in JFUNCTION, which internally means SQLITE_FUNC_UNSAFE, so the JSON
function is treated as unsafe. Clean shell prints 123; buggy shell reports an
"unsafe use of json_extract()" error.
