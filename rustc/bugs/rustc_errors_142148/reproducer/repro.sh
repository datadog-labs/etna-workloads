#!/bin/bash
"$RUSTC" --edition 2021 --crate-type bin --emit metadata --force-warn pub_use_of_private_extern_crate --json future-incompat --error-format json main.rs 2>&1 | grep -c '"level":"warning"'
echo "status: ${PIPESTATUS[0]}"
