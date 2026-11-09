#!/bin/bash
node "$TSC" --noEmit --target es2022 input.ts
echo "exit $?"
