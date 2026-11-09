#!/bin/bash
node "$TSC" --target es2015 --module es2015 --importHelpers --noResolve --outDir out notmodule.cts
cat out/notmodule.cjs
