#!/bin/bash
node "$TSC" --noEmit --strict --pretty false input.ts
echo "exit $?"
