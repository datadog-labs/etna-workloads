Creates a temp TZPATH holding TZif files for America/New_York, Europe/London and `localtime`, then prints `zoneinfo.available_timezones()`.
Clean: `['America/New_York', 'Europe/London']`. Buggy: also includes `'localtime'`.
