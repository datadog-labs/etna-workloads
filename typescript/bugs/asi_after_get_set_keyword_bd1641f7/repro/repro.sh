#!/bin/bash
node "$TSC" --target es2015 --noEmit --strict false input.ts
echo "exit $?"
node "$TSC" --target es2015 --strict false --outFile out.js input.ts
cat out.js
