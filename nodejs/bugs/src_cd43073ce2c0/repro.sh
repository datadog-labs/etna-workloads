#!/bin/bash
# AddLinkedBinding is only reachable from C++ embedders; run the cctest that
# registers 3+ linked bindings, located next to the given node binary.
cc="$(dirname "$1")/cctest"
out="$("$cc" --gtest_filter='LinkedBindingTest.ManyBindingsTest' 2>&1)"
status=$?
echo "$out" | grep -E "No such binding was linked" | head -1
if [ $status -eq 0 ]; then echo "ManyBindingsTest: PASS"; else echo "ManyBindingsTest: FAIL"; fi
exit $status
