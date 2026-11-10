#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata --diagnostic-width=60 --color never -Zwrite-long-types-to-disk=yes main.rs 2>&1 | grep -E '^error' | cut -c1-120
