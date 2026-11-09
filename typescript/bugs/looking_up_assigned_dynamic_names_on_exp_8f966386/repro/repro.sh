#!/bin/bash
node "$TSC" --strict --target es2015 --module commonjs --noEmit input.ts
echo "exit $?"
