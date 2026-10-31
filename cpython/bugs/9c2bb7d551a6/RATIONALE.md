# Rationale

Fix (gh-125115) replaced the `args` positional (`nargs='*'`) + `parse_args()` with `parse_known_args()`, so unknown dash-prefixed args reach the debugged script. In v3.15.2 this logic lives in `parse_args()` in Lib/pdb.py (the first pass already uses `parse_known_args`).

Change: in the script-debugging path (no -p/-m/--/leading dash), re-added the `args` positional with `nargs='*'` and call `parser.parse_args(args)` on the remaining args. This reverses the fix hunk that removed the `args` positional / strict parsing: dash-prefixed script arguments are again rejected as "unrecognized arguments".

Oracle failure: `test_run_script_with_args` fails (`unrecognized arguments: --bar foo`, exit code 2); 2 other test_pdb cases also fail (3 failures total).
