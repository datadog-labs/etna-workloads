#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib main.rs 2>&1 | sed 's/main\.rs/SRC/'
echo "status ${PIPESTATUS[0]}"
