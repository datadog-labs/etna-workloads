repro.sql runs a two-row VALUES whose second row has `CASE 4.2 WHEN 239 IS TRUE ...` (values-20.9).
Clean shell prints `10` and `16`, exit 0. Buggy shell hits the assertion
`exprNodeIsConstant: Assertion pWalker->eCode>0 failed` and aborts (exit 134).
The cause is that the buggy code returns WRC_Prune instead of WRC_Abort after setting eCode=0.
