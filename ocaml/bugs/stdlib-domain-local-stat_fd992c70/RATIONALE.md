# Rationale
The fix gave Hashtbl and Filename a domain-local PRNG (via DLS) instead of one shared lazy PRNG. Reverted in today's code (which uses Domain.DLS keys):

- `stdlib/hashtbl.ml`: `let prng_key = Domain.DLS.new_key ...` -> `let prng = lazy (Random.State.make_self_init())` (global, shared across domains); the two uses in `create` and `rebuild` use `Lazy.force prng`. Reverses hunks `@@ -57,7 +57,13 @@ let randomized`, `@@ -72,7 +78,7 @@ let rec power_2_above`, `@@ -617,7 +623,7 @@ let of_seq`. The blank line after the prng definition was dropped (the pre-fix file had no `current_state` helper), which shifts line numbers in hashtbl.ml; backtrace2.reference's line number for `Hashtbl.find` (changed by the fix's backtrace2.reference hunks) then mismatches.
- `stdlib/filename.ml`: `prng_key` DLS key -> `let prng = lazy(Random.State.make_self_init ())`, and `temp_file_name` uses `Lazy.force prng`. Reverses `@@ -327,13 +327,16 @@ let remove_extension`.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/backtrace/backtrace2.ml => failed.
