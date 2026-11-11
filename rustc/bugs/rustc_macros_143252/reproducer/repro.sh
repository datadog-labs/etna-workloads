#!/bin/bash
"$RUSTC" -Zunpretty=hir --edition=2024 main.rs 2>&1
echo "status $?"
