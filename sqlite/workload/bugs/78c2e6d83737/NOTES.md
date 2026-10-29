Creates a table named `savepoint` with a column named `release`, then inserts, updates and selects.
In 3.54.1 SAVEPOINT and RELEASE are fallback keywords, so they work as identifiers.
The injection removes them from the `%fallback ID` list. The buggy shell then gives a syntax error near "savepoint". The clean shell prints 5.
