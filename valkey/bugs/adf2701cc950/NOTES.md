repro.sh sets foo=1, does SETRANGE foo 2 2 (value "1\0" "2"), then INCRBYFLOAT foo 1.
Clean: "ERR value is not a valid float" and the value is unchanged ("1\0002").
Buggy: the embedded NUL ends parsing early, so strtod accepts "1" and the reply is 2 and foo is overwritten.
