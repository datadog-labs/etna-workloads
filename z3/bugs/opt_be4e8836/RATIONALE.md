Changed hunk: src/src/opt/optsmt.cpp, optsmt::geometric_lex. Removed the block
`if (bound == last_bound && obj.get_infinitesimal().is_pos()) { scopes.push(); bound = mk_ge(obj + inf_eps(step)); search.enter_region(...); }`.
This is the single implementation hunk of FIX.diff (the guard that forces a strictly larger step on a stalled r+k*delta objective), in its current form (scopes/step/search instead of num_scopes/delta_per_step).
Without it, a collapsed blocker breaks the loop and reports a stalled finite value for an unbounded objective.

check.sh result: scaled_min FAIL (infinity coeff: 0 at lp.int_hammer_period=16, assertion inf_val < 0); other units pass.
