#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --error-format json --emit metadata -o out.rmeta main.rs 2>&1 | grep -o '"suggested_replacement":"[^"]*"\|"line_start":[0-9]*,"line_end":[0-9]*,"column_start":[0-9]*,"column_end":[0-9]*' 
echo "status ${PIPESTATUS[0]}"
