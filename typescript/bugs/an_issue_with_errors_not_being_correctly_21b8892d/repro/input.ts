type ActionFunction<
  TExpressionEvent extends { type: string },
  out TEvent extends { type: string }
> = {
  ({ event }: { event: TExpressionEvent }): void;
  _out_TEvent?: TEvent;
};

interface MachineConfig<TEvent extends { type: string }> {
  types: {
    events: TEvent;
  };
  on: {
    [K in TEvent["type"]]?: ActionFunction<
      Extract<TEvent, { type: K }>,
      TEvent
    >;
  };
}

declare function raise<
  TExpressionEvent extends { type: string },
  TEvent extends { type: string }
>(
  resolve: ({ event }: { event: TExpressionEvent }) => TEvent
): {
  ({ event }: { event: TExpressionEvent }): void;
  _out_TEvent?: TEvent;
};

declare function createMachine<TEvent extends { type: string }>(
  config: MachineConfig<TEvent>
): void;

createMachine({
  types: {
    events: {} as { type: "FOO" } | { type: "BAR" },
  },
  on: {
    FOO: raise(({ event }) => {
      return {
        type: "BARx" as const,
      };
    }),
  },
});
