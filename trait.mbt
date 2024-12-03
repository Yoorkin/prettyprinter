///|
pub(open) trait Pretty {
  pretty(Self) -> Document
  to_string(Self) -> String
}

///| Renders a document as a pretty string with a specified width.
///
/// # Arguments
///
/// * `x` - The document to render.
/// * `width` - The maximum width of the rendered string. Defaults to 80.
///
/// # Returns
///
/// The rendered string.
pub fn render[A : Pretty](document : A, width~ : Int = 80) -> String {
  render_document(width, document.pretty())
}

///|
impl Pretty with to_string(self : Self) -> String {
  render_document(80, self.pretty())
}

///|
pub impl Pretty for String with pretty(str : String) { string(str) }

///|
pub impl Pretty for Bool with pretty(b : Bool) { text(b.to_string()) }

///|
pub impl Pretty for Int with pretty(i : Int) { text(i.to_string()) }

///|
pub impl Pretty for Int64 with pretty(i : Int64) { text(i.to_string()) }

///|
pub impl Pretty for UInt with pretty(i : UInt) { text(i.to_string()) }

///|
pub impl Pretty for UInt64 with pretty(i : UInt64) { text(i.to_string()) }

///|
pub impl Pretty for Char with pretty(c : Char) { char(c) }

///|
pub impl Pretty for Double with pretty(d : Double) { text(d.to_string()) }

///|
pub impl Pretty for Document with pretty(doc : Document) { doc }

///|
pub impl[A : Pretty] Pretty for Array[A] with pretty(xs : Array[A]) {
  group(
    char('[') +
    nest(2, softline + separate(char(',') + line, xs.map(A::pretty))) +
    softline +
    char(']'),
  )
}

///|
pub impl[A : Pretty] Pretty for A? with pretty(opt : A?) {
  match opt {
    None => text("None")
    Some(x) => group(text("Some(") + x.pretty() + char(')'))
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Result[A, B] with pretty(
  res : Result[A, B]
) {
  match res {
    Ok(x) => group(text("Ok(") + x.pretty() + char(')'))
    Err(e) => group(text("Err(") + e.pretty() + char(')'))
  }
}

///|
pub impl[A : Pretty, B : Pretty] Pretty for Map[A, B] with pretty(m : Map[A, B]) {
  let entries = m
    .iter()
    .map(fn { (k, v) => group(k.pretty() + char(':') + space + v.pretty()) })
    .to_array()
  group(
    char('{') +
    nest(2, softline + separate(concat(char(','), line), entries)) +
    softline +
    char('}'),
  )
}
