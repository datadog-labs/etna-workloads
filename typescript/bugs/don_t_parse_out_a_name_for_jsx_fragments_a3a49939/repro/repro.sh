#!/bin/bash
node "$TSC" --noEmit --jsx preserve --pretty false input.tsx
echo "exit $?"
