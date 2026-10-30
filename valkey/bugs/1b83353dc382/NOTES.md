Starts a master and a replica, pauses writes on the replica (`client pause ... write`), then writes on the master.
The replica reads the data (slave_read_repl_offset advances) but must not apply it, so slave_repl_offset should stay at the old master offset.
Clean: "applied offset unchanged". Buggy: commandProcessed updates the offset for the paused (blocked) primary client, so "applied offset grew".
