#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --error-format json main.rs 2>&1 | grep -o '"suggestion_applicability":"[A-Za-z]*"' | sort | uniq -c
