#!/bin/bash
node "$TSC" --target es2015 --strict --noEmit input.ts
echo "exit: $?"
