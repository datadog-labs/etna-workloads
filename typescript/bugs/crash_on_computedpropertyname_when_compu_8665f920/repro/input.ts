declare const STATE_SIGNAL: unique symbol;
declare function test(cb: (state: { [STATE_SIGNAL]: unknown }) => void): unknown;
test((state) => {});
