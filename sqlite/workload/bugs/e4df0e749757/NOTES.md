repro.sql creates trigger tr1, then tries to create "tr1" and [tr1] (quoted names) on the same table.
Clean: "trigger "tr1" already exists" / "trigger [tr1] already exists" parse errors.
Buggy: the trigger-hash lookup/insert uses the wrong key length (token length+1 / strlen+1), so the duplicate isn't detected and the statements fail with "out of memory" instead.
