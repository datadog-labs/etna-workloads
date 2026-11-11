#!/bin/bash
"$RUSTC" main.rs -Ccodegen-units=4 -Cdebuginfo=full -Cprefer-dynamic --out-dir out 2>&1 | grep -E "^error" | head -3
echo "status ${PIPESTATUS[0]}"
