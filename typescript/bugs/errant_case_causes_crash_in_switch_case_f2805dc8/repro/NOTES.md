A switch over `123 | 456` with an existing `case "foo!":` and an incomplete `case` gets a "case 123: ..." snippet completion; run.mjs requests its completion entry details via the language service.
Clean: details are returned with name "case 123: ...".
Injected: getCompletionEntryDetails uses `entry.name` of the snippet result instead of `name`, so the returned name differs (or it throws) in this case.
