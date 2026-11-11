#!/bin/bash
"$RUSTC" --edition=2024 --crate-type proc-macro --crate-name closure_hir_span pm.rs -o libclosure_hir_span.so 2>&1
echo "pm status $?"
"$RUSTC" --edition=2024 main.rs --emit metadata --extern closure_hir_span=libclosure_hir_span.so -A unused 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | head -20
echo "status ${PIPESTATUS[0]}"
