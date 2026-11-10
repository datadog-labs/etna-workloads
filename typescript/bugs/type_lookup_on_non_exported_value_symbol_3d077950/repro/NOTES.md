Input declares non-exported values (`const Unit`, `function Fn`, `const X`) that share names with exported types/interfaces.
The script asks the language service for quick info at those identifiers.
Clean reports the value types (e.g. `const Unit: number`, `function Fn(): void`); the injected build looks up the type via the wrong symbol and prints different/incorrect quick info.
