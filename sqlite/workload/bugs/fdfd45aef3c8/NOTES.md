repro.sql: whereL-600 (ticket 1dcb4d44964846ad). Two TEXT tables joined with
`ON x=y WHERE x='good' AND y='good'`.
Clean shell returns `good|good`; buggy shell also returns the wrong row
`bad|good` (constant propagation substitutes the wrong value).
