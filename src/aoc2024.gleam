import argv
import days/day1
import days/day2
import days/day3
import days/day4
import days/day5
import days/day6
import days/day7
import gleam/int
import gleam/io

pub fn main() -> Nil {
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
        3 -> day3.solve()
        4 -> day4.solve()
        5 -> day5.solve()
        6 -> day6.solve()
        7 -> day7.solve()
        _ -> io.println_error("Solution for day #" <> day <> " not found")
      }
  }
}
