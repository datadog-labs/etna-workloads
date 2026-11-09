#!/bin/bash
node "$TSC" --noEmit --target es2015 --lib es2015 input.ts
echo "exit: $?"
