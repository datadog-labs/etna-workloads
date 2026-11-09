Input: a 172-element tuple type alias, quick info requested via the language service with noErrorTruncation=true,
verbosityLevel=1 (and maximumLength unset by default path of the API's truncation).
Clean: the display string is truncated with "... 4 more ..." (maximumLength takes precedence over noErrorTruncation).
Injected: noErrorTruncation wins, so the truncated elements are printed as `any` instead.
