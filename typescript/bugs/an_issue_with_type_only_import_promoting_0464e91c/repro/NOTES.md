Input: `import { TwistyAlgEditor, type TwistyPlayer } from "./other-file"; new TwistyPlayer();` — the language service
is asked for code fixes on the "cannot be used as a value because imported using type" error (TS1361).
The "Remove type from import" fix should just delete the `type ` keyword (clean). The injected build always
deletes the specifier and re-inserts it, even when its position is unchanged, producing different text changes.
