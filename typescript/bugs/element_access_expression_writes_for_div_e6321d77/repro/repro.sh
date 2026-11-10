#!/bin/bash
node "$TSC" --noEmit --strict --target es2015 --pretty false input.ts
echo "exit=$?"
