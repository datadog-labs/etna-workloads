#!/bin/bash
"$RUSTC" --edition 2021 -Zunpretty=expanded main.rs 2>&1 | grep -E 'fn (hash|assert_fields_are_eq)'
