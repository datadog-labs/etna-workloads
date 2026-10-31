Builds a ctypes CField whose bitfield (bit_offset 2 + bit_size 7) overflows a 1-byte type and prints the ValueError message.
Clean: "bit field 'x' overflows its type (2 + 7 > 8)". Buggy: the old format string with missing/wrong args, giving a wrong message (">=" and garbage/missing size).
