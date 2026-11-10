declare namespace JSX {
    interface Element { }
    interface IntrinsicElements {
        foo: {
            className: string;
        }
    }
}
<foo cl={""} />
