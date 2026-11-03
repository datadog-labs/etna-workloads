Reproducer for #79909: the slice backing-store analysis did not treat `range s` as keeping a
pointer to the backing store. The program appends to `s` inside a `range s` loop after
reslicing it; with the bug, the append reuses/overwrites the original backing array that the
range loop is still reading.
Clean prints 1234; buggy prints a different value (the range sees the overwritten 9s).
