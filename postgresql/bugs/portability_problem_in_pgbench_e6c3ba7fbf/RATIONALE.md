# Rationale

The fix replaced srandom()/random() with a 48-bit seed state, for portability. The seed became 64-bit and was parsed and printed with UINT64_FORMAT. Today's code uses pg_prng, so I reverted the same ideas on top of it.

Changed hunks, all in src/bin/pgbench/pgbench.c:

- `set_random_seed()` — traces to the fix hunks that changed `iseed` from `unsigned int` to `uint64`, the `%u` / `UINT64_FORMAT` sscanf, and the "setting random seed" message. `iseed` is `unsigned int` again, so `--random-seed` values above 2^32 are rejected or truncated. The time seed and the seed message are truncated to 32 bits too. `random_seed` therefore holds a 32-bit seed, and the 64-bit seed space is lost.
- `main()`, default_seed setup — traces to the fix hunk that replaced four 16-bit `random()` pieces with two 32-bit draws. It is the reverse of that hunk: the default hash seed is built from four 16-bit-masked draws, so it only carries 16 bits of entropy per piece, not full 64-bit draws.

- `set_random_seed()`, base sequence seeding — traces to the fix hunk that fills `base_random_sequence` from the seed. It is now seeded from the current time and ignores the user's seed. That mirrors the pre-fix dependence on the platform's random(), which OpenBSD does not make deterministic. `--random-seed=N` output is no longer reproducible.

## Oracle cases that fail (9/465)
All in src/bin/pgbench|t/001_pgbench_with_server.pl:
- pgbench expressions stderr: `command=1.: int 17`, `command=2.: int 104`, `command=3.: int 1498`, `command=20.: int 3`
- psql seeded_random count: uniform, exponential, gaussian, zipfian
- transaction count for <P>/001_pgbench_log_3.<N> (10) (missing)
