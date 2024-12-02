import argv
import gleam/io
import day1


pub fn main() {
  case argv.load().arguments {
    [x] -> days(x)
     _ -> io.println_error("Usage: vars <day>") 
  }
}

fn days(day: String) -> Nil {
  case day {
    "day1" -> day1.solve()
    _ -> io.println_error("???")
  }
}