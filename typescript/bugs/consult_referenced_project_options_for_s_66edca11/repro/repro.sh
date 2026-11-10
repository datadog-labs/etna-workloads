#!/bin/bash
node "$TSC" -b lib >/dev/null
node "$TSC" -p app --pretty false; echo "exit $?"
