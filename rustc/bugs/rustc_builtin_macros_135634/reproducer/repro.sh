#!/bin/bash
"$RUSTC" --edition 2021 -Zunpretty=expanded main.rs 2>&1 | grep -B1 -A1 TrivialClone
echo "status: $?"
