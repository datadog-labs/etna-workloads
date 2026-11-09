let value = "";
switch (/** @type {"foo" | "bar"} */ (value)) {
  case "bar":
    /** @type {"bar"} */
    var x = value;
    break;
}
