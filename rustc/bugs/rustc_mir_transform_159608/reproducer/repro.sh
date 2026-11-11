#!/bin/bash
"$RUSTC" -C opt-level=3 --edition 2021 main.rs -o m 2>&1
echo "compile=$?"
s=$(bash -c "./m" >/dev/null 2>&1; echo $?)
echo "run=$s"
