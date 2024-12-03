import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn solve() -> Nil {
  let input = parse_input()
  io.println("Day 3:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() {
  utils.read_input("day3")
  |> string.join("\n")
}

pub fn part1(input) -> Int {
  rec(input, Idle, [], True, One)
  |> list.map(fn(pair) { pair.0 * pair.1 })
  |> list.fold(0, fn(sum, val) { sum + val })
}

pub fn part2(input) -> Int {
  rec(input, Idle, [], True, Two)
  |> list.map(fn(pair) { pair.0 * pair.1 })
  |> list.fold(0, fn(sum, val) { sum + val })
}

type PartNum {
  One
  Two
}

type State {
  Idle
  Open
  FirstNum(left_digits: String)
  Comma(left_digits: String)
  SecondNum(left_digits: String, right_digits: String)
}

fn rec(
  input: String,
  state: State,
  result: List(#(Int, Int)),
  mul_enabled: Bool,
  part_num: PartNum,
) {
  case input {
    "" -> result
    _ ->
      case state {
        Idle ->
          case part_num {
            One ->
              case input {
                "mul(" <> rest -> rec(rest, Open, result, True, One)
                _ ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    result,
                    mul_enabled,
                    part_num,
                  )
              }
            Two ->
              case mul_enabled, input {
                True, "mul(" <> rest ->
                  rec(rest, Open, result, mul_enabled, Two)
                _, "do()" <> rest -> rec(rest, Idle, result, True, Two)
                _, "don't()" <> rest -> {
                  rec(rest, Idle, result, False, Two)
                }
                _, _ ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    result,
                    mul_enabled,
                    part_num,
                  )
              }
          }
        Open ->
          case
            input
            |> string.first
            |> option.from_result()
            |> option.unwrap("")
            |> int.parse
          {
            Ok(x) ->
              rec(
                string.drop_start(input, 1),
                FirstNum(int.to_string(x)),
                result,
                mul_enabled,
                part_num,
              )
            _ ->
              rec(
                string.drop_start(input, 1),
                Idle,
                result,
                mul_enabled,
                part_num,
              )
          }

        FirstNum(left_digits) ->
          case string.first(input) {
            Ok(",") ->
              rec(
                string.drop_start(input, 1),
                Comma(left_digits),
                result,
                mul_enabled,
                part_num,
              )
            char_result -> {
              let char = char_result |> option.from_result |> option.unwrap("")
              case char |> int.parse {
                Ok(_) ->
                  rec(
                    string.drop_start(input, 1),
                    FirstNum(left_digits <> char),
                    result,
                    mul_enabled,
                    part_num,
                  )
                _ ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    result,
                    mul_enabled,
                    part_num,
                  )
              }
            }
          }
        Comma(left_digits) ->
          case
            input
            |> string.first
            |> option.from_result
            |> option.unwrap("")
            |> int.parse
          {
            Ok(x) ->
              rec(
                string.drop_start(input, 1),
                SecondNum(left_digits, int.to_string(x)),
                result,
                mul_enabled,
                part_num,
              )
            _ ->
              rec(
                string.drop_start(input, 1),
                Idle,
                result,
                mul_enabled,
                part_num,
              )
          }
        SecondNum(left_digits, right_digits) ->
          case string.first(input) {
            Ok(")") ->
              case int.parse(left_digits), int.parse(right_digits) {
                Ok(left_val), Ok(right_val) ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    list.append(result, [#(left_val, right_val)]),
                    mul_enabled,
                    part_num,
                  )
                _, _ ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    result,
                    mul_enabled,
                    part_num,
                  )
              }
            char_result -> {
              let char = char_result |> option.from_result |> option.unwrap("")
              case char |> int.parse {
                Ok(_) ->
                  rec(
                    string.drop_start(input, 1),
                    SecondNum(left_digits, right_digits <> char),
                    result,
                    mul_enabled,
                    part_num,
                  )
                _ ->
                  rec(
                    string.drop_start(input, 1),
                    Idle,
                    result,
                    mul_enabled,
                    part_num,
                  )
              }
            }
          }
      }
  }
}
