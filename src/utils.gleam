import simplifile

pub fn read_input(day: String) -> String {
  let file_path = "input/" <> day <> ".txt"
  case simplifile.read(file_path) {
    Ok(x) -> x
    _ -> ""
  }
}
