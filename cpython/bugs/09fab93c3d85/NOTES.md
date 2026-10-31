repro.py folds an address list whose first address fills the line, followed by a non-ASCII display name. Clean: the comma stays plain (',
 =?utf-8?q?H=C3=BCbsch?= ...'). Buggy: the list separator is RFC2047-encoded as '=?utf-8?q?=2C?=' and moved to the next line.
