# Rationale
Single hunk in src/src/model/func_interp.cpp, `func_interp::compress()`: removed the block that,
after `m_entries.shrink(j)`, deallocated and (if >500 entries remain) rebuilt `m_entry_table`.
This undoes the sole implementation hunk of FIX.diff (in today's code the rebuild is via init_table()).
Without it the hash table keeps stale/freed func_entry pointers, so get_entry() returns removed entries.

check.sh result:
FAIL model_evaluator (rc=114)
