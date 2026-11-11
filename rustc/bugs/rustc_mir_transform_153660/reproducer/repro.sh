#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -g -Zmir-opt-level=0 -Zinline-mir -Zmir-enable-passes=+SingleUseConsts,+InstSimplify-after-simplifycfg,+DeadStoreElimination-final,+DestinationPropagation -Zvalidate-mir -Awarnings main.rs -o libmain.rlib 2>&1 | grep -oE 'internal compiler error|is not in debuginfo' | head -3
echo "status=${PIPESTATUS[0]}"
