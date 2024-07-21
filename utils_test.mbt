test "pretty array" {
  let ls = [
    "aaaaaaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbbbbbb", "1111111111111111222222", "3333333333333333",
    "4444",
  ]
  inspect(
    render(ls),
    content=
      #|[
      #|  "aaaaaaaaaaaaaaaa",
      #|  "bbbbbbbbbbbbbbbbbbbbbb",
      #|  "1111111111111111222222",
      #|  "3333333333333333",
      #|  "4444"
      #|]
    ,
  )!
}

test "pretty map" {
  let map = {
    "1000": Some([1, 2, 3, 4, 5]),
    "200": Some([6, 7, 8, 9, 10]),
    "300": None,
    "410": None,
    "50": None,
  }
  let map = { "aaa": Some(map), "bbb": None, "cc": Some({ "0": None }) }
  inspect(
    render(map),
    content=
      #|{
      #|  "aaa": Some({
      #|    "1000": Some([1, 2, 3, 4, 5]),
      #|    "200": Some([6, 7, 8, 9, 10]),
      #|    "300": None,
      #|    "410": None,
      #|    "50": None
      #|  }),
      #|  "bbb": None,
      #|  "cc": Some({"0": None})
      #|}
    ,
  )!
}
