#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target es2015 --pretty false a.js
echo "exit $?"
