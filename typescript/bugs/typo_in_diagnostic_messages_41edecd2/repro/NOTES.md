input.ts imports ./b; tsc is run with --traceResolution.
The trace line for the found file reads "File '.../b.ts' exists - use it as a name resolution result." on clean,
but "File ... exist - use it ..." (typo) on injected.
