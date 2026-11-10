Input: `switch (true)` with a fallthrough group (`case typeof x === "string": case typeof x === "number":`) followed by `default`.
Clean: x is narrowed to string | number in the group and to boolean in default, so there are no errors.
Injected: only the last clause expression of the group is used and earlier cases are not excluded, so tsc reports type errors.
