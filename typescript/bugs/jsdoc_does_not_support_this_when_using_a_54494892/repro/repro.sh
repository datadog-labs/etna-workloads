#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target es2015 a.js
echo "exit $?"
