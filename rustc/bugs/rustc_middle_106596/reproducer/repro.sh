#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata --diagnostic-width=40 -Zwrite-long-types-to-disk=yes -Zunstable-options main.rs --out-dir out 2>&1 | grep -v '^ *= note: the full'
echo "status ${PIPESTATUS[0]}"
