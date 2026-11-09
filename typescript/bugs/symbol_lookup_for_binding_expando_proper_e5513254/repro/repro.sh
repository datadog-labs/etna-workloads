#!/bin/bash
node "$TSC" --noEmit --strict --target es2015 --declaration input.ts
echo "exit $?"
