Parent parser has `--foodle`/`--foonly`; subparser `bar` has `--fo`/`--foonew`.
`parse_args(['bar', '--fo', 'baz'])` should give `fo='baz'`. With the bug, the parent
checks ambiguity while pre-scanning all args, so `--fo` (ambiguous in the parent) raises
"ambiguous option" even though the subparser consumes it.
