Calls getpass._raw_input with echo_char='*' and input 'endstart
' (Ctrl+A = move to start). Clean: returns 'startend' with line-editing redraws; buggy: Ctrl+A is not handled, returns 'endstart' and plain echo.
