Runs `COMMAND GETKEYS ZUNIONSTORE target 260 key1..key260`. ZUNIONSTORE has two key specs, so the
result buffer must grow on the second spec while already holding `target`.
Clean: first key is `target`. Buggy: the buffer is resized without keeping earlier entries, so the
first position is uninitialised and the reply starts with `zunionstore` (argv[0]) instead of `target`.
