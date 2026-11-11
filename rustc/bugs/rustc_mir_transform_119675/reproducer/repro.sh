#!/bin/bash
"$RUSTC" --edition 2021 -Zmir-opt-level=2 -Zunpretty=mir main.rs 2>&1 | grep -c switchInt
