`repro.sql` runs `format('<%j>','abc'||char(0x1f)||'def')`.
Clean shell prints `<abc\u001fdef>`; the buggy shell fails to escape the 0x1f control character (the check was `<0x1f` instead of `<=0x1f`), so it emits the raw byte.
