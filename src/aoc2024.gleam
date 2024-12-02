import argv
import day1
import day2
import gleam/int
import gleam/io

pub fn main() {
  case argv.load().arguments {
    [x] -> days(x)
    _ -> io.println_error("Usage: gleam run <number>")
  }
}

fn days(day: String) -> Nil {
  case int.parse(day) {
    Error(_) -> io.println_error("Usage: argument must be a number")
    Ok(x) ->
      case x {
        1 -> day1.solve()
        2 -> day2.solve()
        _ -> io.println_error("Solution for day #" <> day <> " not found")
      }
  }
}
