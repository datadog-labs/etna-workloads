#!/bin/bash
"$RUSTC" --edition 2021 --emit=obj -o out.o -A internal_features -Cdebug-assertions=yes -Cpanic=abort lib.rs 2>&1
echo "status=$?"
