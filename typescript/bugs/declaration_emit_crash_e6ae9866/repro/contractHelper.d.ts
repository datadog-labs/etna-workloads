export function handleParamGovernance(zcf: any): {
  publicMixin: {
    getGovernedParams: () => globalThis.ERef<import("./types.js").ParamStateRecord>;
  };
};
