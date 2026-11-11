#!/bin/bash
"$RUSTC" main.rs --edition=2024 -Znext-solver=globally --emit metadata --crate-type lib -A unused 2>&1 | grep -E "^error|panicked|assertion" 
echo "status: ${PIPESTATUS[0]}"
