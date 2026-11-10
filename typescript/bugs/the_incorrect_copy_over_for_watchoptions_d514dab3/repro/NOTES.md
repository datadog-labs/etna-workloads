Parses a.json (extends base.json, overrides watchOptions.watchFile) and b.json (extends base.json only) with a shared extendedConfigCache via the public API.
Clean: b.json keeps base's watchFile=fixedPollingInterval.
Injected: a.json's merge mutates base's cached watchOptions in place, so b.json wrongly gets watchFile=useFsEvents.
