# Rationale

Fix hunk (src/networking.c, postWriteToClient): added the replica branch
`server.stat_net_repl_output_bytes += c->nwritten > 0 ? c->nwritten : 0;`.

In 9.0.7 that branch calls `postWriteToReplica(c)`, which begins with
`if (c->nwritten <= 0) return; server.stat_net_repl_output_bytes += c->nwritten;`.
I removed that one stat-update line from `postWriteToReplica` (src/networking.c).
This is equivalent to the pre-fix state: replica writes go through
postWriteToClient but never update `total_net_repl_output_bytes`.

Oracle failure: "Replica output bytes metric" fails with
`Expected '0' to be more than '0'`. The other cases still pass.
