function createProps<T>(t: T) {
  function getProps() {}
  function createVariants() {}

  getProps.createVariants = createVariants;
  return getProps;
}

createProps({}).createVariants();
