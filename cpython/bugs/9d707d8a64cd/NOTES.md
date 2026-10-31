Parses a message with a header line starting with a colon using a policy with raise_on_defect=True.
Clean: InvalidHeaderDefect is raised via policy.handle_defect. Buggy: the defect is appended directly to
msg.defects, so nothing is raised and the parse succeeds (prints `[InvalidHeaderDefect('Missing header name.')]`).
