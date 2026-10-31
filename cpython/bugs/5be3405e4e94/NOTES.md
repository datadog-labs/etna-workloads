Builds a mutually exclusive group mixing optionals and a positional, with a usage line long enough to wrap, and prints format_usage().
Clean keeps the `|` separators across the optionals/positionals boundary; buggy produces differently wrapped usage (see check.sh output).
