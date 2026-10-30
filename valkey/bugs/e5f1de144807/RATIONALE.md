# Rationale

fix.patch contains only the merge header (no hunks); the upstream fix (#5141) made XADD with
MAXLEN/trim behave consistently with XTRIM for propagation. In 9.0.7 the equivalent logic is the
trim block in `xaddCommand` (src/t_stream.c).

Change: the rewrite of the approx specifier and trim argument (`streamRewriteApproxSpecifier` /
`streamRewriteTrimArgument`) is moved inside the `if (streamTrim(...))` branch, so it only happens
when something was actually deleted. That makes XADD differ from XTRIM, where the rewrite is done
only on deletion, and the case of a trim that doesn't delete (e.g. a limited/approx trim hitting
a node boundary) no longer rewrites the argument to the exact value.

Failing oracle cases (tests/unit/type/stream.tcl):
- "XADD with ~ MAXLEN can propagate correctly"
- "XADD with ~ MINID can propagate correctly"
The replica/AOF re-executes the unrewritten `~` trim and diverges (xlen 102 expected).
