pg_waldump --foo >/dev/null 2>&1
echo "exit nonzero: $([ $? -ne 0 ] && echo yes || echo no)"
