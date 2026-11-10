Input: an enum with non-ASCII string members (`A = "é"`, `B = "日本"`); the script asks the language service for quick info on `E.A` and `E.B`.
Clean prints the constant values as written (`E.A = "é"`). Injected escapes them (`E.A = "é"`) because getTextOfConstantValue uses escapeNonAsciiString.
