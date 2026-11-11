#!/bin/bash
"$RUSTC" --crate-type lib --crate-name alias --edition 2021 alias.rs --emit metadata,link -o libalias.rlib 2>/dev/null
"$RUSTC" --edition 2021 main.rs --emit metadata -L . -o main.rmeta 2>&1 | grep -E "^error|panicked" | sed 's/thread .* panicked.*/PANIC/'
echo "status ${PIPESTATUS[0]}"
