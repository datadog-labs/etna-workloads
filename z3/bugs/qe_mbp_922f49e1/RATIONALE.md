Changed hunk: src/src/qe/mbp/mbp_dt_tg.cpp, mbp_dt_tg::impl::apply().
Traces to the only implementation hunk of FIX.diff. Today's code has the guard (a check of the
recognizer in the model, adding a negated recognizer literal and skipping rm_accessor). I removed
that guard, so rm_accessor is again called unconditionally for any accessor whose argument has a
variable. When the model gives the argument a different constructor, rm_accessor asserts a
contradictory is-cons literal, so QEL returns false or misbehaves (#9571).

check.sh output:
BUILD OK
FAIL mbp_qel (rc=139)  (segfault in the test)
