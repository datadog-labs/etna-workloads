#!/bin/bash
node "$TSC" --noEmit --target es2017 input.ts
echo "exit $?"
