repro.sh starts a primary with hide-user-data-from-log yes, opens a raw TCP connection that does PSYNC (becoming a replica), then sends an unknown command `notacommand secretvalue`. The primary logs "== CRITICAL == This primary is sending an error to its replica: ...".
Clean: the log shows '*redacted*' (prints REDACTED). Buggy: the error text leaks `secretvalue` into the log (prints LEAKED).
