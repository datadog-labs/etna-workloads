Calls fts3_tokenizer() with a NULL first argument (one-arg lookup, and two-arg with 8- and 4-byte blobs), with tokenizer changes enabled via .dbconfig.
Clean shell: "unknown tokenizer: " / "argument type mismatch" errors. Buggy shell: the NULL name is passed to the hash lookup, which crashes or misbehaves.
