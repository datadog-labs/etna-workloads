Disassembles pickles with a non-ASCII STRING / SHORT_BINSTRING argument via pickletools.dis.
Clean: prints the disassembly (args shown via ascii(), e.g. 'caf\xe9').
Buggy: read_stringnl decodes with "ascii", so dis raises UnicodeDecodeError on the first pickle.
