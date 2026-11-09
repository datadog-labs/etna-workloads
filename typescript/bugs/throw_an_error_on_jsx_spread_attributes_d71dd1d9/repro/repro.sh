#!/bin/bash
node "$TSC" --noEmit --jsx preserve --strict input.tsx
echo "exit $?"
