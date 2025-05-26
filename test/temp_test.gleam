import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import wordle

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn add_letter_full_test() {
  let test_list = [
    #(list.repeat("", 5), "s"),
    #("s" |> string.to_graphemes |> list.append(list.repeat("", 4)), "t"),
    #("st" |> string.to_graphemes |> list.append(list.repeat("", 3)), "a"),
    #("sta" |> string.to_graphemes |> list.append(list.repeat("", 2)), "r"),
    #("star" |> string.to_graphemes |> list.append(list.repeat("", 1)), "k"),
    #("stark" |> string.to_graphemes |> list.append(list.repeat("", 0)), "9"),
  ]

  let expected_list = [
    "s" |> string.to_graphemes |> list.append(list.repeat("", 4)),
    "st" |> string.to_graphemes |> list.append(list.repeat("", 3)),
    "sta" |> string.to_graphemes |> list.append(list.repeat("", 2)),
    "star" |> string.to_graphemes |> list.append(list.repeat("", 1)),
    "stark" |> string.to_graphemes |> list.append(list.repeat("", 0)),
    "stark" |> string.to_graphemes |> list.append(list.repeat("", 0)),
  ]

  test_list
  |> list.map2(expected_list, fn(t, e) {
    t.0 |> wordle.add_letter(t.1) |> should.equal(e)
  })
}

pub fn remove_letter_full_test() {
  let test_list = [
    list.repeat("", 5),
    "s" |> string.to_graphemes |> list.append(list.repeat("", 4)),
    "st" |> string.to_graphemes |> list.append(list.repeat("", 3)),
    "sta" |> string.to_graphemes |> list.append(list.repeat("", 2)),
    "star" |> string.to_graphemes |> list.append(list.repeat("", 1)),
    "stark" |> string.to_graphemes |> list.append(list.repeat("", 0)),
  ]

  let expected_list = [
    list.repeat("", 5),
    list.repeat("", 5),
    "s" |> string.to_graphemes |> list.append(list.repeat("", 4)),
    "st" |> string.to_graphemes |> list.append(list.repeat("", 3)),
    "sta" |> string.to_graphemes |> list.append(list.repeat("", 2)),
    "star" |> string.to_graphemes |> list.append(list.repeat("", 1)),
  ]

  test_list
  |> list.map2(expected_list, fn(t, e) {
    t |> wordle.old_dont_use_remove_letter |> should.equal(e)
  })
}

pub fn simpler_remove_letter_full_test() {
  let test_list = [
    list.repeat("", 5),
    "s" |> string.to_graphemes |> list.append(list.repeat("", 4)),
    "st" |> string.to_graphemes |> list.append(list.repeat("", 3)),
    "sta" |> string.to_graphemes |> list.append(list.repeat("", 2)),
    "star" |> string.to_graphemes |> list.append(list.repeat("", 1)),
    "stark" |> string.to_graphemes |> list.append(list.repeat("", 0)),
  ]

  let expected_list = [
    list.repeat("", 5),
    list.repeat("", 5),
    "s" |> string.to_graphemes |> list.append(list.repeat("", 4)),
    "st" |> string.to_graphemes |> list.append(list.repeat("", 3)),
    "sta" |> string.to_graphemes |> list.append(list.repeat("", 2)),
    "star" |> string.to_graphemes |> list.append(list.repeat("", 1)),
  ]

  test_list
  |> list.map2(expected_list, fn(t, e) {
    t |> wordle.remove_letter |> should.equal(e)
  })
}
