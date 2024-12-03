///|
pub(open) trait Pretty {
  pretty(Self) -> Document
}

///|
pub impl Pretty for String with pretty(str) { string(str) }

///|
pub impl Pretty for Bool with pretty(b) { text(b.to_string()) }

///|
pub impl Pretty for Int with pretty(i) { text(i.to_string()) }

///|
pub impl Pretty for Int64 with pretty(i) { text(i.to_string()) }

///|
pub impl Pretty for UInt with pretty(i) { text(i.to_string()) }

///|
pub impl Pretty for UInt64 with pretty(i) { text(i.to_string()) }

///|
pub impl Pretty for Char with pretty(c) { char(c) }

///|
pub impl Pretty for Double with pretty(d) { text(d.to_string()) }

///|
pub impl Pretty for Document with pretty(doc) { doc }

///|
pub impl[A : Pretty] Pretty for Array[A] with pretty(xs) {
  group(
    char('[') +
    nest(softline + separate(char(',') + line, xs.map(A::pretty))) +
    softline +
    char(']'),
  )
}

///|
pub impl[A : Pretty] Pretty for A? with pretty(opt) {
  match opt {
    None => text("None")
    Some(x) => group(text("Some(") + x.pretty() + char(')'))
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Result[A, B] with pretty(res) {
  match res {
    Ok(x) => group(text("Ok(") + x.pretty() + char(')'))
    Err(e) => group(text("Err(") + e.pretty() + char(')'))
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Map[A, B] with pretty(m) {
  let entries = m
    .iter()
    .map(fn { (k, v) => group(k.pretty() + char(':') + space + v.pretty()) })
    .to_array()
  group(
    char('{') +
    nest(softline + separate(concat(char(','), line), entries)) +
    softline +
    char('}'),
  )
}

///|
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
            softline +
            separate(char(',') + line, xs.map(Pretty::pretty)) +
            softline,
          ),
        ),
      )
    Object(map) =>
      group(
        braces(
          nest(softline + separate_map(text(",") + line, map.to_array(), pair)) +
          softline,
        ),
      )
  }
}
