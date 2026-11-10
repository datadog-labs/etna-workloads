declare namespace JSX {
  interface IntrinsicElements { h1: { children: string } }
  type Element = string;
  interface ElementChildrenAttribute { offspring: any; }
}
const Title = (props: { children: string }) => <h1>{props.children}</h1>;
<Title>Hello</Title>;
export {};
