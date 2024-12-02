import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import utils

pub fn parse_input() -> #(List(Int), List(Int)) {
  utils.read_input("day1")
  |> string.split(on: "\n")
  |> list.map(fn(line) {
    case string.split(line, on: "   ") {
      [a, b] -> {
        case int.parse(a), int.parse(b) {
          Ok(i), Ok(k) -> Ok([i, k])
          _, _ -> Error("Input must be numbers")
        }
      }
      _ -> Error("Input must be in pairs")
    }
  })
  |> list.fold(from: #([], []), with: fn(acc, val) {
    case val {
      Ok([x, y]) -> #(list.append(acc.0, [x]), list.append(acc.1, [y]))
      _ -> acc
    }
  })
}

pub fn solve() {
  let input = parse_input()

  let p1 = part1(input)
  io.println("Part 1: " <> int.to_string(p1))

  let p2 = part2(input)
  io.println("Part 2: " <> int.to_string(p2))
}

pub fn part1(input: #(List(Int), List(Int))) {
  let x = list.sort(input.0, by: int.compare)
  let y = list.sort(input.1, by: int.compare)

  list.zip(x, y)
  |> list.fold(from: 0, with: fn(acc, val) {
    acc + int.absolute_value(val.0 - val.1)
  })
}

pub fn part2(input: #(List(Int), List(Int))) {
  let freq =
    list.fold(input.1, dict.new(), fn(acc, item) {
      dict.upsert(acc, update: item, with: fn(x) {
        case x {
          Some(i) -> i + 1
          None -> 1
        }
      })
    })

  list.fold(input.0, from: 0, with: fn(acc, key) {
    acc
    + case dict.get(freq, key) {
      Ok(key_frequency) -> key_frequency * key
      _ -> 0
    }
  })
}
