declare module "events" {
  class EventEmitter {}
  export = EventEmitter;
}
declare module "node:events" {
  import events = require("events");
  export = events;
}
