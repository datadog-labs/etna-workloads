Sets a trace function, then sets f_trace and f_trace_opcodes=True on the current frame
(the upstream test's scenario, in-process). Clean: opcode events are delivered, prints
`True`. Buggy: the frame setters no longer enable INSTRUCTION monitoring, so no opcode
events fire and it prints `False`.
