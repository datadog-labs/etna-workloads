#!/bin/bash
"$RUSTC" --edition=2024 -Zunpretty=hir main.rs 2>&1
echo "status $?"
