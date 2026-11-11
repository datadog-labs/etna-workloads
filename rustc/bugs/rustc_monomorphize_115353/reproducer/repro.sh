#!/bin/bash
"$RUSTC" --crate-name rmeta_meta --crate-type rlib -C prefer-dynamic=no --emit=metadata aux.rs
echo "aux status: $?"
"$RUSTC" main.rs -C prefer-dynamic=no -L . --extern rmeta_meta=librmeta_meta.rmeta 2>&1 | grep -E '^error' 
echo "main status: ${PIPESTATUS[0]}"
