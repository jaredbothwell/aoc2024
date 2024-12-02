import gleam/string
import simplifile

pub fn read_input(day: String) -> List(String) {
  let file_path = "input/" <> day <> ".txt"
  case simplifile.read(file_path) {
    Ok(x) -> string.split(x, on: "\n")
    _ -> []
  }
}
