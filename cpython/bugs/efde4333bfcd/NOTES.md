Runs `profiling.sampling` CLI `replay` on a file that is not a binary profile.
Clean: SystemExit "Error: Input file is not a binary sampling profile ... --binary".
Buggy: no header validation, so BinaryReader is opened directly and a different error/exception occurs.
