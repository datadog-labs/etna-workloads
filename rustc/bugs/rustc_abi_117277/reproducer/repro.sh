#!/bin/bash
"$RUSTC" --target i686-unknown-linux-gnu --crate-type lib --emit=obj -o out.o lib.rs 2>&1
echo "status: $?"
