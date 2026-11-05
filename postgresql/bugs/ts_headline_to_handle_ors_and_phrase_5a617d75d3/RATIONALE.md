# Rationale

Reverted the ts_headline() cover search in `src/src/backend/tsearch/wparser_def.c`
to its pre-fix form. This is the main implementation of fix_impl.patch. The
supporting `TS_execute_locations` code in tsvector_op.c and ts_utils.h is left
in place. It is now unused, so the revert does not touch it.

- `hlCover`: fix hunk "hlCover: try to find a substring..." is reverted. The old
  `hlFirstIndex` and the O(N^2) `pmin/pmax` scan bounded by `max_cover` are back.
  The scan runs `TS_execute` on word-index ranges. It no longer uses lexeme
  positions or the AND'ed term/phrase locations, so ORs and phrase queries are
  handled less accurately.
- `mark_hl_fragments` and `mark_hl_words`: the `locations` / `nextpos` parameters
  are removed and the `max_cover` parameter is restored. `p++` is restored at the
  end of each cover loop.
- `prsd_headline`: the `max_cover` computation is restored. The
  `TS_execute_locations` call is removed.
- `checkcondition_HL`: only the comment hunks differ, so I left them alone.

Failing oracle case: src/test/regress||tsearch
