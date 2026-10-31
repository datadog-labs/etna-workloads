Calls POP3._putcmd on an unconnected instance (with _putline stubbed) using commands containing CRLF/NUL.
Clean: raises ValueError("Control characters not allowed in commands"). Buggy: the command is passed through to _putline (command injection).
