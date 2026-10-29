Creates an FTS4 table whose indexed column `poiCategory` is a prefix of the notindexed column `poiCategoryId`.
Clean: MATCH 'restaurant' returns the row, MATCH '6021' returns nothing.
Buggy: the prefix match wrongly marks `poiCategory` as notindexed, so 'restaurant' returns nothing and '6021' matches.
