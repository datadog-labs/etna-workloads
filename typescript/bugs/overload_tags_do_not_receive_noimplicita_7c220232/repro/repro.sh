#!/bin/bash
node "$TSC" --noEmit --allowJs --checkJs --noImplicitAny --target es2015 a.js
echo "exit $?"
