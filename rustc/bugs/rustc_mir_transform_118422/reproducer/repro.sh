#!/bin/bash
$RUSTC --edition 2021 -Cpanic=unwind --crate-type=lib -Cprefer-dynamic=no aux.rs --crate-name aux 2>&1 | head -5
echo "aux=$?"
$RUSTC --edition 2021 -Cpanic=abort -Cprefer-dynamic=no main.rs -L . 2>&1 | grep -E "error|Cannot" | head -5
echo "main=${PIPESTATUS[0]}"
[ -x ./main ] && ./main
