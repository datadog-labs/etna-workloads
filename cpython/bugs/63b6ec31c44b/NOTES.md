Runs an inline `Pdb(skip=['__main__']).set_trace()` with scripted stdin ("p x", "c").
Fixed: inline breakpoints stop unconditionally, so output contains the prompt and `42`.
Buggy: dispatch_opcode checks stop_here() (skip pattern matches), so it never stops and output is empty.
