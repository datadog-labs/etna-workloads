repro.sh runs `EVAL "error('a\r\nb')" 0` (plus redis.error_reply cases). Clean build sanitizes the
newline in the error message ("a  b script: ..."); buggy build emits the raw CRLF, so the
reply is truncated/malformed ("ERR user_script:1: a") and the rest of the message is lost.
