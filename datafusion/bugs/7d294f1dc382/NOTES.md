Reproducer: copies the nullif.slt dictionary cases added by the fix (NULLIF on Dictionary(Int32, Utf8) vs Utf8 literal, Utf8 column vs dictionary, dictionary vs dictionary).

Clean build returns results for all three queries. Buggy build (dictionary coercion removed from comparison_coercion_numeric) fails the first two with a planning error "Dictionary(Int32, Utf8) and Utf8 is not comparable"; only the dictionary-vs-dictionary query works.
