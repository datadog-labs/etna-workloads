declare namespace JSX {
  interface Element {}
  interface IntrinsicElements { div: {} }
  interface ElementChildrenAttribute { children: {} }
}
interface A { icon: string; children(p: { onClose: () => void }): JSX.Element; controls?: undefined }
interface B { icon: string; controls: string[]; children?: undefined }
declare function DropdownMenu(props: A | B): JSX.Element;

<DropdownMenu icon="move">
  {({ onClose }) => <div />}
</DropdownMenu>;
