#!/bin/bash
node "$TSC" --target es2015 --noEmit input.ts
echo "exit: $?"
