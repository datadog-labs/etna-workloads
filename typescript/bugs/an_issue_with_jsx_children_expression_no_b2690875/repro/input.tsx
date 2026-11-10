declare global { namespace JSX {
  interface Element {}
  interface IntrinsicElements {}
  interface ElementChildrenAttribute { children: {} }
} }
type Props =
  | { renderNumber?: false; children: (arg: string) => void }
  | { renderNumber: true; children: (arg: number) => void };
declare function Foo(props: Props): JSX.Element;
export const a = <Foo>{(value) => {}}</Foo>;
export const b = <Foo renderNumber>{(value) => {}}</Foo>;
