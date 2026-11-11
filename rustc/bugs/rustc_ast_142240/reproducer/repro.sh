#!/bin/bash
"$RUSTC" --crate-type lib --check-cfg "cfg(docsrs,test)" --emit metadata -o out.rmeta main.rs 2>&1 | grep -E "^(error|warning)|panicked" | head -5
echo "status ${PIPESTATUS[0]}"
