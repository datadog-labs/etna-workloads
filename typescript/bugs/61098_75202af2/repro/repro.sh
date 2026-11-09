#!/bin/bash
node "$TSC" --noEmit --target es2015 --pretty false input.ts
echo "exit: $?"
