#!/bin/bash
"$RUSTC" t.rs --error-format json --out-dir . > out.txt 2>&1
echo "status: $?"
grep -c "unmatched" out.txt
grep -oE "panicked at|assertion failed" out.txt | sort -u
