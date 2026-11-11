#!/bin/bash
"$RUSTC" --edition 2021 -C debug-assertions main.rs -o a 2>&1
bash -c './a >/dev/null 2>&1; echo "exit=$?"' 2>/dev/null
