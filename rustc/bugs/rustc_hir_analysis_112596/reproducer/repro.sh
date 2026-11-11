#!/bin/bash
"$RUSTC" --edition=2021 --crate-type=lib --emit=metadata --error-format=json -o out.rmeta main.rs 2>&1 | grep -o '"suggested_replacement":"[^"]*"'
