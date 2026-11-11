Compiles an indexing expression on a slice with -Zvalidate-mir; the injected compiler ICEs because the lowered PtrMetadata is rejected in pre-runtime MIR, while the clean compiler builds and runs it.
