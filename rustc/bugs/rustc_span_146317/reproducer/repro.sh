#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --out-dir . --check-cfg 'cfg()' -Zcheck-cfg-all-expected main.rs 2>&1
echo "status $?"
