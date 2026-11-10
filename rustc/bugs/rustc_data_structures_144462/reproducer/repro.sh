#!/bin/bash
# Auto-generated from tests/ui/self-profile/pretty_print_no_ice.rs
cd "$(dirname "$0")"
"$RUSTC" -Zself-profile={{build-base}} -Zself-profile-events=args -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
