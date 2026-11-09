#!/bin/bash
node "$TSC" --strict --target es2015 --noEmit input.ts
echo "exit $?"
