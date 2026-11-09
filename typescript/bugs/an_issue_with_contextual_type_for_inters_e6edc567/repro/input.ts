type Action<TEvent extends { type: string }> = (ev: TEvent) => void;

interface MachineConfig2<TEvent extends { type: string }> {
  schema: { events: TEvent };
  on?: {
    [K in TEvent["type"] as K extends Uppercase<string> ? K : never]?: Action<TEvent extends { type: K } ? TEvent : never>;
  } & {
    "*"?: Action<TEvent>;
  };
}

declare function createMachine2<TEvent extends { type: string }>(
  config: MachineConfig2<TEvent>
): void;

createMachine2({
  schema: { events: {} as { type: "FOO" } | { type: "bar" } },
  on: {
    FOO: (ev) => {
      ev.type;
    },
  },
});
