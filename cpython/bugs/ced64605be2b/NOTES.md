Reproducer: sets ExceptionGroup.args to () and (1,) then calls repr(). Clean prints the repr with the exceptions tuple; buggy reads args[1] out of bounds (crash/garbage/assert).
