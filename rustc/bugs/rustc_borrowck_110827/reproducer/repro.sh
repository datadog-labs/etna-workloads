#!/bin/bash
"$RUSTC" --edition=2018 --crate-type=lib --emit=metadata --error-format=human --color=never main.rs 2>&1 | grep -E '^(help|LL|[0-9 ]*[-+|] *type)|type Lazy'
echo "status ${PIPESTATUS[0]}"
