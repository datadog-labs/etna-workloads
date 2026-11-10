#!/bin/bash
$RUSTC --edition 2024 --crate-type lib --error-format short -Zunstable-options main.rs 2>&1
$RUSTC --edition 2024 --crate-type lib main.rs 2>&1 | grep -A3 '^help'
echo "exit ${PIPESTATUS[0]}"
