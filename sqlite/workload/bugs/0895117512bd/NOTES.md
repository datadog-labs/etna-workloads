Reproducer: repro.sql creates a trigger whose body contains an oversized hex literal (`0x2147483648e0e0099`), then fires it with an INSERT.

Clean shell: "Parse error near line 5: hex literal too big: ..." (exit 1).
Buggy shell: assertion failure `aLabel!=0` in resolveP2Values (abort, exit -6), because the trigger program's ops are taken even though a parse error occurred.
