/**
 * @param {{ a?: { json?: string[] }}} [config]
 */
function f1({ a: { json = [] } = {} } = {}) { return json }
