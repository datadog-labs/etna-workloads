`repro.sql` runs `SELECT DISTINCT -0x08000000000000000;` (the hexlit-402 case).
Clean shell: error "hex literal too big: -0x08000000000000000", exit 1.
Buggy shell: accepts the oversized literal and prints -9223372036854775808, exit 0.
