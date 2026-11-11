#!/bin/bash
mkdir -p inc out
out=$("$RUSTC" main.rs --edition=2021 --emit=metadata -C incremental=inc -Z incremental-verify-ich --out-dir out 2>&1)
st=$?
echo "$out" | head -5
echo "status: $st"
