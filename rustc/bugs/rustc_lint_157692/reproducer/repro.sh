#!/bin/bash
"$RUSTC" --edition=2021 --crate-type proc-macro --crate-name pm pm.rs 2>&1
echo "pm status $?"
"$RUSTC" --edition=2021 --emit metadata --extern pm=libpm.so main.rs 2>&1 | grep -E "^(error|warning)|panicked" | head -5
echo "status ${PIPESTATUS[0]}"
