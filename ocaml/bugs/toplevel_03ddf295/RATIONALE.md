# Rationale

## Change: parsing/location.ml (single file)

1. Removed the helper `lines_around_from_phrasebuf` (reads source lines from
   the toplevel phrase buffer). Reverses fix hunk
   `@@ -546,6 +547,23 @@ let lines_around_from_lexbuf` (which added it).

2. In `lines_around_from_current_input`, the match is back to
   `match !input_lexbuf with | Some lb -> ... | None -> ...`, dropping the
   `_, Some pb, "//toplevel//"` case that took lines from the phrase buffer.
   Reverses fix hunk
   `@@ -583,15 +601,22 @@ let lines_around_from_current_input ~start_pos ~end_pos =`.
   The result: for long toplevel phrases, where the lexbuf has been refilled
   and no longer holds the start of the phrase, the error highlighting has no
   source lines to show. That is bug #7925.

Hunks I left alone on purpose: the `input_phrase_buffer` declaration in
location.ml/.mli and the toplevel code that fills it (now in
toplevel/topcommon.ml and toplevel/toploop.ml). toplevel/ is not on the list
of directories I'm allowed to edit, and nothing reads the buffer once the
consumer above is gone, so the bug comes back without touching them.

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
  : build OK; error_highlighting.ml => failed, pr6468.ml => passed
- Final: `make clean && make -j8 && make -j8 ocamltest` (exit 0), then
  `sh run-oracle.sh` (exit 1): error_highlighting.ml => failed,
  pr6468.ml => passed

RESULT: injected
