declare namespace JSX {
  interface Element {}
  interface IntrinsicElements { div: {} }
}
declare const n: number;
const a = <div {...n} />;
