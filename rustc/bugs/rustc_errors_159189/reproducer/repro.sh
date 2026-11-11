#!/bin/bash
$RUSTC --crate-type lib --emit metadata --diagnostic-width=12 --error-format=human -Zwrite-long-types-to-disk=no --out-dir . main.rs 2>&1
echo "status=$?"
