#!/bin/bash
node "$TSC" --noEmit --strict --target es2015 --jsx preserve input.tsx
echo "exit $?"
