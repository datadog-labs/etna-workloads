#!/bin/bash
node "$TSC" --noEmit --target es2015 types.d.ts foo.ts; echo "exit $?"
