repro.sql runs three REGEXP queries using `{0,N}` (from regexp1-5.1, 5.3, 5.5).
Clean shell prints 0, 1, 1. Buggy shell prints 1, 0, 0, because the `{0,N}` bytecode is miscompiled (iPrev is not advanced after the FORK insert).
