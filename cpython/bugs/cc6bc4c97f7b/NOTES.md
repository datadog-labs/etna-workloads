repro.py passes a memoryview of an array('i') with 5000 elements (20000 bytes) as
`input=` to Popen.communicate() on a child that echoes stdin, then prints the
output length and whether it matches.

Clean: 20000 20000 True. Buggy: 16384 20000 False. Without the byte cast in
`_make_input_view`, len(input_view) counts elements, not bytes. The byte offset
is compared against the element count and used as an element index, so the write
stops early and the input is truncated.

The element count must exceed PIPE_BUF (4096 here) for the truncation to show.
