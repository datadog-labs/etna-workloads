#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --crate-type lib main.rs 2>&1 | sed 's/^ *--> .*/  -->/'
echo "status: ${PIPESTATUS[0]}"
