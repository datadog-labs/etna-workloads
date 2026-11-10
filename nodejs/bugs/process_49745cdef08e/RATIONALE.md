# process: delay throwing an error using `throwDeprecation`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 49745cdef08e43d87123058798497bba49879c93 applied to v26.13.0 (clean).

Upstream commit message:

```
process: delay throwing an error using `throwDeprecation`

This makes sure all warnings that were triggered before a deprecation
warning during the same tick are properly handled and logged.

It also guarantees that users can not catch the error anymore.

Fixes: https://github.com/nodejs/node/issues/17871

PR-URL: https://github.com/nodejs/node/pull/32312
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Michaël Zasso <targos@protonmail.com>
```
