interface Attrs {
    [key: `do-${string}`]: Function;
    "ns:thing"?: string;
}
declare global {
    namespace JSX {
        interface IntrinsicElements { div: Attrs }
    }
}
export const tag = <div ns:thing="a" />;
