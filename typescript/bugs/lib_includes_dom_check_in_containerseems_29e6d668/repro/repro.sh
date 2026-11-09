#!/bin/bash
node "$TSC" --noEmit --target es2015 --lib es5,dom input.ts
echo "exit $?"
