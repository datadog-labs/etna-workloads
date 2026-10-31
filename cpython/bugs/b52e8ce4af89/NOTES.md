Reproducer: compiles `女女女=1; 女女女/` (a SyntaxError with wide CJK chars before the error column) and prints the formatted traceback.
Clean: the caret is padded by display width (wide chars count as 2 columns), so it lines up under the error.
Buggy: the caret is padded by character count, so it sits too far left.
