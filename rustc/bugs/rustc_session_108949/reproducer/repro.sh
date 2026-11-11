#!/bin/bash
"$RUSTC" --crate-type=lib --emit=metadata -Zunstable-options --target=target.json --check-cfg='cfg()' lib.rs 2>&1
echo "exit=$?"
