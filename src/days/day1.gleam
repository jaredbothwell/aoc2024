import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import utils

pub fn solve() -> Nil {
  let input = parse_input()
  io.println("Day 1:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() -> #(List(Int), List(Int)) {
  utils.read_input("day1")
  |> list.fold([], fn(acc, line) {
    case string.split(line, "   ") {
      [] | [_] | [_, _, _, ..] -> acc
      [first, second] -> {
        case int.parse(first), int.parse(second) {
          Error(_), _ | _, Error(_) -> acc
          Ok(parsed_first), Ok(parsed_second) ->
            list.append(acc, [#(parsed_first, parsed_second)])
        }
      }
    }
  })
  |> list.unzip()
}

pub fn part1(input: #(List(Int), List(Int))) -> Int {
  list.zip(list.sort(input.0, int.compare), list.sort(input.1, int.compare))
  |> list.fold(0, fn(sum, pair) { sum + int.absolute_value(pair.0 - pair.1) })
}

pub fn part2(input: #(List(Int), List(Int))) -> Int {
  let freq = get_frequency_dict(input.1)
  list.fold(input.0, 0, fn(sum, key) {
    sum
    + case dict.get(freq, key) {
      Ok(key_frequency) -> key_frequency * key
      _ -> 0
    }
  })
}

fn get_frequency_dict(items: List(value)) -> Dict(value, Int) {
  list.fold(items, dict.new(), fn(dict, item) {
    dict.upsert(dict, item, fn(x) {
      case x {
        Some(i) -> i + 1
        None -> 1
      }
    })
  })
}
