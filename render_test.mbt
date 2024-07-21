test "pretty group" {
  let doc = group(text("hello") + nest(2, hardline + text("world")))
  inspect(
    Pretty::to_string(doc),
    content=
      #|hello
      #|  world
    ,
  )!
}
