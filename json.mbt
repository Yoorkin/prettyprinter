pub impl Pretty for @json.JsonValue with pretty(json : @json.JsonValue) -> Document {
  fn pair(pair : (String, @json.JsonValue)) -> Document {
    string(pair.0) + text(":") + space + Pretty::pretty(pair.1)
  }

  match json {
    True => text("true")
    False => text("false")
    Null => text("null")
    Number(n) => Pretty::pretty(n)
    String(s) => text(s)
    Array(xs) =>
      group(
        brackets(
          nest(
            2,
            softline +
            separate(char(',') + line, xs.map(Pretty::pretty)) +
            softline,
          ),
        ),
      )
    Object(map) =>
      group(
        braces(
          nest(
            2,
            softline + separate_map(text(",") + line, map.to_array(), pair),
          ) +
          softline,
        ),
      )
  }
}

test "json" {
  let json : Json = {
    "key1": 1.0,
    "key2": 2099889.0,
    "key3": 11100991.0,
    "key4": 20000000.0,
    "obj": { "a": true, "b": true },
    "obj2": {
      "a": true,
      "b": true,
      "obj3": { "a": true, "b": true },
      "obj4": { "a": true, "b": true },
    },
    "key3": [true, false, Null],
  }
  inspect!(
    render(json),
    content=
      #|{
      #|  "key1": 1,
      #|  "key2": 2099889,
      #|  "key3": [true, false, null],
      #|  "key4": 20000000,
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
