Runs `python -m mimetypes a.txt b.html` (via runpy). Clean prints a type line for each input;
buggy returns after the first input, so the second file is never reported.
