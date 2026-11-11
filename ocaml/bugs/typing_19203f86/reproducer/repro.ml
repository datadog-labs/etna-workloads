type dep [@@deprecated "deprecated"]
class type c = object
  val a : dep
  [@@@warning "-3"]
  val x : dep
end
