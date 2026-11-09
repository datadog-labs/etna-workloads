Language service completions at `import ` in a JS file (allowJs), with TS modules exporting classes, interfaces, a default class/interface, and re-exports.
Clean: auto-import completions list only value symbols (classes, incl. re-exported/export-list ones and the default class).
Injected: symbolAppearsToBeTypeOnly doesn't skip aliases, so re-exported/aliased symbols are judged wrongly and the listed completions differ (type-only ones appear or value ones go missing).
