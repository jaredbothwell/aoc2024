import gleam/int
import gleam/io
import gleam/list
import gleam/string
import utils

pub fn solve() -> Nil {
  let input = parse_input()
  io.println("Day 4:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() {
  utils.read_input("day4")
  |> string.split("\n")
  |> list.map(fn(line) { string.split(line, "") })
}

pub fn part1(input: List(List(String))) -> Int {
  let directions = [
    #(0, 1),
    #(1, 0),
    #(0, -1),
    #(-1, 0),
    #(1, 1),
    #(-1, -1),
    #(-1, 1),
    #(1, -1),
  ]
  list.index_fold(input, 0, fn(result, row, i) -> Int {
    result
    + list.index_fold(row, 0, fn(row_count, char, j) {
      case char {
        "X" ->
          row_count
          + list.fold(directions, 0, fn(position_count, dir) {
            case get_substring(input, #(i, j), dir, 4) {
              "MAS" -> position_count + 1
              _ -> position_count
            }
          })
        _ -> row_count
      }
    })
  })
}

pub fn part2(input) -> Int {
  list.index_fold(input, 0, fn(result, row, i) -> Int {
    result
    + list.index_fold(row, 0, fn(row_count, char, j) {
      case char {
        "A" ->
          row_count
          + {
            let source = #(i, j)
            let distance = 2
            let top_left = get_substring(input, source, #(-1, -1), distance)
            let bottom_right = get_substring(input, source, #(1, 1), distance)
            let top_right = get_substring(input, source, #(-1, 1), distance)
            let bottom_left = get_substring(input, source, #(1, -1), distance)
            case top_left, bottom_right {
              "M", "S" | "S", "M" ->
                case top_right, bottom_left {
                  "M", "S" | "S", "M" -> 1
                  _, _ -> 0
                }
              _, _ -> 0
            }
          }
        _ -> row_count
      }
    })
  })
}

fn get_substring(
  grid: List(List(String)),
  source: #(Int, Int),
  direction: #(Int, Int),
  length: Int,
) -> String {
  list.range(1, length - 1)
  |> list.map(fn(distance_from_source) {
    grid
    |> utils.at_index(source.0 + distance_from_source * direction.0, [])
    |> utils.at_index(source.1 + distance_from_source * direction.1, "")
  })
  |> string.join("")
}
