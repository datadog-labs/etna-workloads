#!/bin/bash
"$RUSTC" --edition=2024 --emit metadata --out-dir . -Zunpretty=hir main.rs 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | head -20
echo "status: ${PIPESTATUS[0]}"
