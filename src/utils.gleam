import gleam/list
import gleam/option

import simplifile

pub fn read_input(day: String) -> String {
  let file_path = "input/" <> day <> ".txt"
  case simplifile.read(file_path) {
    Ok(x) -> x
    _ -> ""
  }
}

pub fn sum(l: List(Int)) -> Int {
  list.fold(l, 0, fn(acc, x) { acc + x })
}

pub fn product(l: List(Int)) -> Int {
  list.fold(l, 1, fn(acc, x) { acc * x })
}

pub fn at_index(list: List(a), index: Int, default: a) {
  // list.drop returns whole list when using a negative index but I need an empty list instead
  let i = case index {
    x if x < 0 -> list.length(list)
    x -> x
  }

  list
  |> list.drop(i)
  |> list.first
  |> option.from_result
  |> option.unwrap(default)
}
