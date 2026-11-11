#!/bin/bash
d=inc; rm -rf $d
"$RUSTC" --edition 2021 --crate-type bin --cfg v1 -C incremental=$d -o out main.rs 2>&1; echo "s1=$?"
"$RUSTC" --edition 2021 --crate-type bin -C incremental=$d -o out main.rs 2>&1; echo "s2=$?"
