import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import utils

pub fn solve() {
  let input = parse_input()
  io.println("Day 1:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() -> #(List(Int), List(Int)) {
  utils.read_input("day1")
  |> list.fold(from: [], with: fn(acc, line) {
    case string.split(line, on: "   ") {
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

pub fn part1(input: #(List(Int), List(Int))) {
  list.zip(
    list.sort(input.0, by: int.compare),
    list.sort(input.1, by: int.compare),
  )
  |> list.fold(from: 0, with: fn(sum, pair) {
    sum + int.absolute_value(pair.0 - pair.1)
  })
}

pub fn part2(input: #(List(Int), List(Int))) {
  let freq =
    list.fold(input.1, dict.new(), fn(dict, item) {
      dict.upsert(dict, update: item, with: fn(x) {
        case x {
          Some(i) -> i + 1
          None -> 1
        }
      })
    })

  list.fold(input.0, from: 0, with: fn(sum, key) {
    sum
    + case dict.get(freq, key) {
      Ok(key_frequency) -> key_frequency * key
      _ -> 0
    }
  })
}
