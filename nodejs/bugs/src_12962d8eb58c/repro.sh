#!/bin/bash
# Sibling Environments sharing one isolate/loop can only be created through the
# embedder API, so run the embedder test (cctest) built alongside the node binary.
dir=$(dirname "$1")
out=$("$dir/cctest" --gtest_filter=EnvironmentTest.FreeEnvironmentWhileSiblingHasActiveHandles 2>&1)
st=$?
echo "$out" | grep -E '^\[  (PASSED|FAILED)  \]|^\[       (OK|FAILED) \]' | sed -E 's/ \([0-9]+ ms( total)?\)//' | sort -u
echo "exit=$st"
[ $st -eq 0 ]
