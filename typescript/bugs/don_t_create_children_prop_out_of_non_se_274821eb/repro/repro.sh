#!/bin/bash
node "$TSC" --noEmit --strict --jsx preserve --target es2015 input.tsx
echo "exit=$?"
