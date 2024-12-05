import gleam/list
import gleam/string
import simplifile

pub fn read_input(day: String) -> List(String) {
  let file_path = "input/" <> day <> ".txt"
  case simplifile.read(file_path) {
    Ok(x) -> string.split(x, on: "\n")
    _ -> []
  }
}

pub fn sum(l: List(Int)) -> Int {
  list.fold(l, 0, fn(acc, x) { acc + x })
}

pub fn product(l: List(Int)) -> Int {
  list.fold(l, 1, fn(acc, x) { acc * x })
}
