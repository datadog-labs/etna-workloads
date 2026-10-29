Table with a virtual column before a real column; UPDATE ... RETURNING b.
The buggy shell uses the declared column index instead of the storage index
for RETURNING's register, so it returns the wrong value (clean: 123).
