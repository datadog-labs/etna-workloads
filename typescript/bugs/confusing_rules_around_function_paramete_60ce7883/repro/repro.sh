#!/bin/bash
node "$TSC" --noEmit --target es2015 input.ts
echo "exit: $?"
