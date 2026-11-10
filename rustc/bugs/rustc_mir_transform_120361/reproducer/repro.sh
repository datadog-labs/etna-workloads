#!/bin/bash
"$RUSTC" --edition=2021 -O -Ccodegen-units=1 main.rs -o main 2>&1; echo "rustc=$?"
./main 2>&1; echo "run=$?"
