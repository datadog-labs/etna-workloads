# Rationale

Fix gh-121151: members of a mutually exclusive group were previously joined into
one unbreakable usage part (`[a | b | c]`), so long groups could not wrap.

In v3.15.2 `_get_actions_usage_parts` (Lib/argparse.py) was restructured: the
`inserts`-based code is gone and each group member is a separate part, with
`' |'` appended to every member and the open/close bracket attached to the
first/last. That is the post-fix behaviour (separators on individual parts so
wrapping can happen between them).

Change: in the `if in_group:` block, join the group's parts again into a single
part with `open + ' | '.join(parts[start:]) + close` and `del parts[start+1:]`.
This restores the pre-fix single-part output, which the fix's hunk replaced with
per-part separators and brackets.

Failing oracle cases (10 in test_argparse): the mutually-exclusive usage
wrapping tests, e.g. `test_usage_when_required` / `test_usage_when_not_required`
(expected `... [--fghij FGHIJ] (--klmno KLMNO |\n  --pqrst PQRST)` but got the
group moved whole onto the next line), and `test_long_mutex_groups_wrap`-style
cases where a long group is not wrapped between alternatives.
