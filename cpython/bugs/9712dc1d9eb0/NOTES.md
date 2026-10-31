Passes a list whose first element's `__str__` clears the list to Tcl (`interp.call('set','_',values)`).
Clean: prints `('value', 'pad')`. Buggy: the old AsObj iterates the list without a snapshot, reading freed items, and segfaults (exit -11).
