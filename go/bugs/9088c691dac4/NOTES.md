repro.go: a loop keeping 13 integer values live while materializing several float64 comparisons
(`a == float64(v)` -> CMOVQEQF/SETEQF, which need an integer temp register).
Under high register pressure the buggy regalloc picks the temp mask without excluding nospill
(input) registers, so allocReg finds no register.
Clean: compiles and prints 82291. Buggy: `internal compiler error: 'f': no register available`, exit 1.
Found by fuzzing; the upstream test issue57846.go itself does not trigger the bug with go1.27.3's regalloc.
