pub impl Pretty for @json.JsonValue with pretty(json : @json.JsonValue) -> Document {
  fn pair(pair : (String, @json.JsonValue)) -> Document {
    string(pair.0) + text(":") + space + Pretty::pretty(pair.1)
  }

  match json {
    @json.True => text("true")
    @json.False => text("false")
    @json.Null => text("null")
    @json.Number(n) => Pretty::pretty(n)
    @json.String(s) => text(s)
    @json.Array(xs) =>
      group(
        brackets(
          nest(
            2,
            softline + separate(char(',') + line, xs.map(Pretty::pretty)) + softline,
          ),
        ),
      )
    @json.Object(map) =>
      group(
        braces(
          nest(
            2,
            softline + separate_map(text(",") + line, map.to_array(), pair),
          ) + softline,
        ),
      )
  }
}

test "json" {
  let json = @json.Object(
    {
      "key1": @json.Number(1.0),
      "key2": @json.Number(2099889.0),
      "key3": @json.Number(11100991.0),
      "key4": @json.Number(20000000.0),
      "obj": @json.Object({ "a": @json.True, "b": @json.True }),
      "obj2": @json.Object(
        {
          "a": @json.True,
          "b": @json.True,
          "obj3": @json.Object({ "a": @json.True, "b": @json.True }),
          "obj4": @json.Object({ "a": @json.True, "b": @json.True }),
        },
      ),
      "key3": @json.Array([@json.True, @json.False, @json.Null]),
    },
  )
  inspect!(
    render(json),
    content=
      #|{
      #|  "key1": 1.0,
      #|  "key2": 2099889.0,
      #|  "key3": [true, false, null],
      #|  "key4": 2.0e7,
      #|  "obj": {"a": true, "b": true},
      #|  "obj2": {
      #|    "a": true,
      #|    "b": true,
      #|    "obj3": {"a": true, "b": true},
      #|    "obj4": {"a": true, "b": true}
      #|  }
      #|}
    ,
  )
}
