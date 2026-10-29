repro.sql: attaches a temp-file db, creates aux.t1, a TEMP trigger tr1 on it, then a temp.t1 with the same name; detaches aux, then drops tr1.
Fixed shell prints `done`. The buggy shell's trigger-unlink loop runs off the end of the list (the trigger is no longer on temp.t1's list), so it crashes or asserts.
