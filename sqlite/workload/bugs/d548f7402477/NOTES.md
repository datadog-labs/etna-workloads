Reproducer (`repro.sql`): an fts5 trigram table; highlight() queried with overlapping-token matches ('def ghi', 'efg ghi', 'abc AND cde').

Clean: `abc(defghi)jklm`, `abcd(efghi)jklm`, `[abcde]`.
Buggy: `abc(def)(ghi)jklm`, `abcd(efg)hijklm(ghi)jklm` (text duplicated), `[abc]de[cde]`.
Highlights for overlapping trigram tokens are not merged, and text is output wrongly.
