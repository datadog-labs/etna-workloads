RUSTC_LOG=trace RUSTC_ICE=0 "$RUSTC" main.rs -o out >log.txt 2>&1
echo "status $?"
grep -c 'panicked\|internal compiler error' log.txt
exit 0
