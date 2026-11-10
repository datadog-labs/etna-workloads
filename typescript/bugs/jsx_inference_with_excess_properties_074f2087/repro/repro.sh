#!/bin/bash
node "$TSC" --strict --noEmit --jsx preserve --target es2015 input.tsx
echo "exit: $?"
