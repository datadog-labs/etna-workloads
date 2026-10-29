Runs group_concat(x) as a sliding window (ROWS 2 PRECEDING) with the default separator.
The injection removes the code that sets nFirstSepLength for the default ',' separator, so
xInverse drops the wrong number of characters. The buggy shell returns wrong group_concat
strings (see ./check.sh); the clean shell returns 1 / 1,2 / 1,2,3 / 2,3,4 / 3,4,5.
