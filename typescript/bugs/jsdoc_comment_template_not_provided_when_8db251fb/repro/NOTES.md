Input: a JS file with an unrelated `/** @typedef {string} Id */` comment, then an empty `/** */` above `function foo(x, y, z)`.
The script calls `getDocCommentTemplateAtPosition` inside the empty comment.
Clean: the template includes `@param x/y/z`. Injected: the typedef's tags make it skip the params, so the template is a bare comment.
