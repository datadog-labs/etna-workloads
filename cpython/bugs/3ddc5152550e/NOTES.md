repro.py writes -1, 2**32 and 2**64-1 into the T_UINT and T_ULONG members of
_testcapi's structmembers test type, printing the stored value and the warnings.
With the bug, writing -1 to T_UINT emits an extra "Truncation of value to
unsigned int" warning after "Writing negative value into unsigned field".
The clean build emits only the negative-value warning.
