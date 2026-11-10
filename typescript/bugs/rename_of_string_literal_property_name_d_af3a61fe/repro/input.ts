type Props = {
  foo: boolean;
}

let { foo }: Props = null as any;
foo;

let asd: Props = { "foo": true };
