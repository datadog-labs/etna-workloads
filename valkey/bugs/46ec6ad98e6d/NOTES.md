Reproducer: starts a server, makes AOFRW slow (rdb-key-save-delay), enables AOF dynamically
(`config set appendonly yes`), then kills the AOFRW child so the first rewrite fails.

Clean: AOF data goes to a temp INCR file that is deleted on failure, so no manifest exists
(`manifest files: 0`). Buggy: a real INCR file is opened and the manifest is persisted
even though no BASE exists (`manifest files: 1`).
