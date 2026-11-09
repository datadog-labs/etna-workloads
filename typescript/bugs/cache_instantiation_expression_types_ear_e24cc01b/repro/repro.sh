#!/bin/bash
node "$TSC" --target es2015 --noEmit input.ts 2>/dev/null
echo "exit $?"
