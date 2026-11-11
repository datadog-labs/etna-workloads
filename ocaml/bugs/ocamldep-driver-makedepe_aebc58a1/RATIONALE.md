# Rationale
The upstream fix ("Fix check-typo errors") is a formatting-only refactor of `find_module_in_load_path` in driver/makedepend.ml (hunk `@@ -89,12 +89,17 @@ let add_to_synonym_list`), which scopes `uname` inside `unames`. It has no behavioural change, so to make a test fail I re-expressed the touched code with a bug in the same spot:
- driver/makedepend.ml: `let uname = Unit_info.normalize name` -> `let uname = name`, so the uncapitalized-name lookup (`unames`) no longer matches lowercase file names. Touches the `unames` definition from that hunk.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tool-ocamldep-shadowing/a.ml failed; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle -> failed.
