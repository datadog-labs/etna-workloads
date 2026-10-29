A view over a table without an INTEGER PRIMARY KEY selects `rowid` (iPKey = -1).
The clean shell names the view column "rowid"; the buggy shell indexes
aCol[-1] (assertion failure or garbage column name).
