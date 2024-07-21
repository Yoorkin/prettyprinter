
/// This function takes a separator document, an array of values, and a mapping function, and returns a document
/// where each value in the array is mapped to a document using the mapping function, and then separated by the separator document.
///
/// # Arguments
///
/// * `sep` - The separator document to be used between each mapped value.
/// * `xs` - The array of values to be mapped and separated.
/// * `f` - The mapping function that takes a value from the array and returns a document.
///
/// # Returns
///
/// The resulting document where each value is mapped and separated by the separator document.
///
/// # Example
///
/// ```
/// let result = render(separate_map(text(","), [1,2,3], text))
/// println(result) // output: 1,2,3,4,5
/// ```
pub fn separate_map[A](sep : Document, elems : Array[A], f : (A) -> Document) -> Document {
  separate(sep, elems.map(f))
}

/// This function takes a separator document `sep` and an array of documents `docs` and returns a document
/// where each document in the array is separated by the separator document.
///
/// # Example
///
/// ```
/// let sep = text("-");
/// let docs = [text("Hello"), text("World"), text("!")];
/// let result = separate(sep, docs);
/// println(render(result)) // Hello-World-!
/// ```
pub fn separate(sep : Document, docs : Array[Document]) -> Document {
  let cat_by_sep = fn(l, r) { concat(l, concat(sep, r)) }
  match docs {
    [] => empty
    [x, .. as xs] => xs.iter().fold(cat_by_sep, x)
  }
}

/// Surrounds the given document with the left and right documents.
/// `surround(l, r, doc)` is equivalent to `l + doc + r`
pub fn surround(left : Document, right : Document, doc : Document) -> Document {
  left + doc + right
}

/// `parens(text("doc")) == "(doc)"`
pub fn parens(doc : Document) -> Document {
  surround(char('('), char(')'), doc)
}

/// `brackets(text("doc")) == "[doc]"`
pub fn brackets(doc : Document) -> Document {
  surround(char('['), char(']'), doc)
}

/// `braces(text("doc")) == "{doc}"`
pub fn braces(doc : Document) -> Document {
  surround(char('{'), char('}'), doc)
}

pub fn string(str : String) -> Document {
  surround(char('"'), char('"'), text(str))
}

