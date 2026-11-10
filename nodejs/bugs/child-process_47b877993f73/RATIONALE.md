# child_process: fix incomplete prototype pollution hardening

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 47b877993f73ac28467e004ce7533eb6a707ec58 applied to v26.13.0 (clean).

Upstream commit message:

```
child_process: fix incomplete prototype pollution hardening

Prior pull request (#48726) hardened against prototype pollution
vulnerabilities but effectively missed some use-cases which
opened a window for prototype pollution for some child_process
functions such as spawn(), spawnSync(), and execFileSync().

PR-URL: https://github.com/nodejs/node/pull/53781
Reviewed-By: Vinícius Lourenço Claro Cardoso <contact@viniciusl.com.br>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
```
