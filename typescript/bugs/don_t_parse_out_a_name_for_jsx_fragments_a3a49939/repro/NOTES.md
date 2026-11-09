input.tsx has a JSX fragment `<>...</div>` closed with a named closing tag.
Clean tsc reports the "Expected corresponding closing tag for JSX fragment" error at the closing `>` position.
Injected tsc parses the name `div` in the closing fragment and reports that error at the name's range instead (different column/diagnostics).
