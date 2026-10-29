Reproducer: `repro.sql` runs three `json_patch()` calls from json104-200/210/220.
Null members in the patch should be removed. The clean shell prints `{}`, `{"y":1}` and `{"a":{"bb":{}}}`.
The buggy shell keeps the null members: `{"x":null}`, `{"x":null,"y":1,"z":null}` and `{"a":{"bb":{"ccc":null}}}`.
