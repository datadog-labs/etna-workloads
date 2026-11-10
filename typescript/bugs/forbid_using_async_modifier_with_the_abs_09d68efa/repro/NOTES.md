input.ts declares an abstract class with methods using both `abstract async` and `async abstract` modifiers.
Clean build reports TS1243 ("'async' modifier cannot be used with 'abstract' modifier") on them.
Injected build reports no errors for these.
