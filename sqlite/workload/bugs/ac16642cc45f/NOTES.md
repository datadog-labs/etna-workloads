repro.sql selects zero rows in `.mode json` and `.mode jobject`.
Clean shell prints nothing. Buggy shell emits a stray closing `}]` / `}` even though no rows were output (qrfFinalize lacks the nRow>0 check).
