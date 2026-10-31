repro.py compiles the bytes `#coding=U7+AA0''\n` (a UTF-7 cookie that decodes to a carriage return) with compile().
Clean: compiles fine (prints `('',)`). Buggy: SystemError "bad argument to internal function", because the string tokenizer no longer normalizes newlines after decoding.
