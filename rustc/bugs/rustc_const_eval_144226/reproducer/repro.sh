#!/bin/bash
"$RUSTC" --edition 2021 -Zmir-enable-passes=+GVN -Zvalidate-mir -Zdeduplicate-diagnostics=no main.rs 2>&1
echo "exit=$?"
