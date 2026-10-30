Reproducer: XADD 1-0, then two entries with ms ~1641544570597 (delta from the master entry overflows int32), then XTRIM MINID 1641544570597-0 and XRANGE.
Clean: XTRIM removes 1 entry; XRANGE returns the two remaining entries.
Buggy: lpGetInteger is truncated to int, so the big ms delta is misread; XTRIM returns 3 (removes everything) and XRANGE is empty.
