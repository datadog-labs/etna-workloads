repro.sql: round(1e500) and round(-1e500) return Inf/-Inf on the clean shell but 0.0/0.0 on the buggy shell (round() mishandles infinities when AtoF reports failure).
