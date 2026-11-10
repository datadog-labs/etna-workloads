# Bug
`node:v8` serdes (DefaultSerializer/Deserializer) did not know about Float16Array, so serializing one threw "Unserializable host object".

# Changes (lib/v8.js)
- Removed `Float16Array` from the primordials `globalThis` destructuring (fix hunk 1; here it was a top-level primordial name).
- Removed `if (type === '[object Float16Array]') return 13;` from arrayBufferViewTypeToIndex (fix hunk 3).
- Removed `if (index === 13) return Float16Array;` from arrayBufferViewIndexToType (fix hunk 4).
The eslint config and test hunks of the fix are not touched.

# Failing test
parallel/test-v8-serdes: `Error: Unserializable host object: Float16Array(4) [ 1, 2, 3, 4 ]` at DefaultSerializer._writeHostObject.
