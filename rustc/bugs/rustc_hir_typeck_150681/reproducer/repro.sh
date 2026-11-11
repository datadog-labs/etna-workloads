#!/bin/bash
"$RUSTC" --edition=2021 main.rs -o out 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | head -8
echo "status ${PIPESTATUS[0]}"
[ -x out ] && ./out && echo ran
