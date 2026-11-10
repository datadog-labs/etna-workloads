#!/bin/bash
node "$TSC" --noEmit --target es2015 --strict input.ts
echo "exit $?"
