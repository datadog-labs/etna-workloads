Completions inside an empty object literal typed as `{key1:string} | {key2:number} | Uppercase<string>`; prints the property-kind entries.
Clean lists `key1,key2`; injected (Primitive flag no longer includes StringMapping) also offers `length`, i.e. string members from Uppercase<string>.
