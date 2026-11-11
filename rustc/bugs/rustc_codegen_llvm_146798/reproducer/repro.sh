#!/bin/bash
"$RUSTC" --crate-type bin --emit metadata -Zcheck-cfg-all-expected --check-cfg='cfg()' --out-dir . main.rs 2>&1 | tr ',' '\n' | grep -c 'zkne_or_zknd'
