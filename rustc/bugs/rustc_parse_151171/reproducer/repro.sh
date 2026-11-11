#!/bin/bash
"$RUSTC" --crate-type lib --emit=metadata -o out.rmeta main.rs 2>&1
echo "status: $?"
