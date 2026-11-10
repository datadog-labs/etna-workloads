#!/bin/bash
"$RUSTC" --edition 2021 -A warnings main.rs -o m 2>&1
./m; echo "status $?"
