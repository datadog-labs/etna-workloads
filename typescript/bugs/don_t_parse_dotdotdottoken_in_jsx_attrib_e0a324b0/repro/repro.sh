#!/bin/bash
node "$TSC" --jsx react --target es2015 --noEmit false --outFile out.js input.tsx
echo "exit $?"
cat out.js
