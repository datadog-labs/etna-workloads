repro.sql: UTF-16be database with an index on a column holding U+307F (its UTF-8 form ends in 0xBF).
`word GLOB 'み*'` is turned into an index range word>=X AND word<Y. The buggy build increments the
last UTF-8 byte (0xBF -> 0xC0) without carrying, so the upper bound is wrong in UTF-16be and the
row is missed. The clean shell prints 1; the buggy shell prints 0.
