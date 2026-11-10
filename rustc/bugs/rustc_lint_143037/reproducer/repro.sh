#!/bin/bash
"$RUSTC" --edition 2021 --target hexagon-unknown-linux-musl --crate-type lib --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit=$?"
