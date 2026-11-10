A class has an uninitialized property `d` whose type is inferred from `this.d = value` in the constructor (strict mode).
The script asks the language service for inlay hints with property-declaration type hints enabled.
Clean prints `[[": number",22]]`; injected prints `[]` because it skips property declarations without an initializer.
