#!/bin/bash
"$RUSTC" --crate-type lib --crate-name samename --emit metadata,link dep.rs -o libsamename.rlib 2>&1
"$RUSTC" --crate-name samename --emit metadata --extern samename=libsamename.rlib main.rs 2>&1 | grep -E '^error' | head -3
echo "status: ${PIPESTATUS[0]}"
