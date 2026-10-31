Calls `_pyrepl.utils.gen_colors` on f-strings containing literal doubled braces (`f"a{{b}}c"`, `f"{{"`) and prints the color spans.
On the clean build, FSTRING_MIDDLE spans ending in a brace include the brace (e.g. Span(2, 4)); the buggy build always subtracts 1 from the end, so the spans are one character short (Span(2, 3)).
