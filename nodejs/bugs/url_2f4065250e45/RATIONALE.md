# url: throw error if argument length of revokeObjectURL is 0

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2f4065250e453da2de2ee9cbb8aaae28cbdb4df5 applied to v26.13.0 (clean).

Upstream commit message:

```
url: throw error if argument length of revokeObjectURL is 0

Added a check to see if url wasn't included as an argument
which will then throw an error.

Fixes: https://github.com/nodejs/node/issues/50432
PR-URL: https://github.com/nodejs/node/pull/50433
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Vinícius Lourenço Claro Cardoso <contact@viniciusl.com.br>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Zeyu "Alex" Yang <himself65@outlook.com>
```
