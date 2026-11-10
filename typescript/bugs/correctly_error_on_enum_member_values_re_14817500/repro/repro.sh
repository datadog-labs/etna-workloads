#!/bin/bash
node "$TSC" --noEmit --target es2020 input.ts
echo "exit $?"
