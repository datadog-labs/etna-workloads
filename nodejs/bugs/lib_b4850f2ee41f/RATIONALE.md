# lib: make event static properties non writable and configurable

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b4850f2ee41f3429214eb2733d70656113e4ad22 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: make event static properties non writable and configurable

The idl definition for Event makes the properties constant
this means that they shouldn't be configurable and writable.
However, they were, and this commit fixes that.

Fixes: https://github.com/nodejs/node/issues/50417
PR-URL: https://github.com/nodejs/node/pull/50425
Reviewed-By: Vinícius Lourenço Claro Cardoso <contact@viniciusl.com.br>
Reviewed-By: Matthew Aitken <maitken033380023@gmail.com>
```
