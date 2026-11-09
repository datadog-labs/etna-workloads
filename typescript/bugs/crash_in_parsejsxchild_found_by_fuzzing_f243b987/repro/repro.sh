#!/bin/bash
node "$TSC" --allowJs --noEmit --target es2015 a.js
echo "exit $?"
