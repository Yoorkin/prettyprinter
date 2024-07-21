test "pretty group" {
  let doc = @prettyprinter.group(
    @prettyprinter.text("hello") + @prettyprinter.nest(
      2,
      @prettyprinter.hardline + @prettyprinter.text("world"),
    ),
  )
  inspect!(
    @prettyprinter.Pretty::to_string(doc),
    content=
      #|hello
      #|  world
    ,
  )
}
