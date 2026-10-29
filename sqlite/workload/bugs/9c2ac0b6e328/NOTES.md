repro.sql calls decimal('999999999999999', N) with N=1 and 14 (all leading digits 9, no fraction, rounds up).
Clean shell prints 1000000000000000; buggy shell prints a corrupted "1000000000000000.a" (digit overflow gives a bogus digit and a bad fraction count).
