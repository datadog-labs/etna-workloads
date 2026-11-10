for (const k of ['NONE','CAPTURING_PHASE','AT_TARGET','BUBBLING_PHASE']) {
  console.log(k, JSON.stringify(Object.getOwnPropertyDescriptor(Event, k)));
}
