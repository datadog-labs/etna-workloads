declare namespace JSX {
  interface IntrinsicElements {
    'my-el': {
      /** This also appears */
      'prop:foo': string;
    };
  }
}
const x = <my-el prop:foo="bar" />;
