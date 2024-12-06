import gleam/int
import gleam/io
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
}

pub fn part1(input) -> Int {
  rec(input, Idle, 0, True, One)
}

pub fn part2(input) -> Int {
  rec(input, Idle, 0, True, Two)
}

type PartNum {
  One
  Two
}

type State {
  Idle
  Open
  FirstNum(left_digits: String)
  Comma(left_val: Int)
  SecondNum(left_val: Int, right_digits: String)
}

fn rec(
  input: String,
  state: State,
  result: Int,
  mul_enabled: Bool,
  part_num: PartNum,
) {
  case input {
    "" -> result
    _ ->
      case state {
        Idle ->
          case part_num, mul_enabled, input {
            One, _, "mul(" <> rest | Two, True, "mul(" <> rest ->
              rec(rest, Open, result, mul_enabled, part_num)
            Two, _, "do()" <> rest -> rec(rest, Idle, result, True, Two)
            Two, _, "don't()" <> rest -> {
              rec(rest, Idle, result, False, Two)
            }
            _, _, _ ->
              rec(
                string.drop_start(input, 1),
                Idle,
                result,
                mul_enabled,
                part_num,
              )
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
          case string.first(input), int.parse(left_digits) {
            Ok(","), Ok(left_val) ->
              rec(
                string.drop_start(input, 1),
                Comma(left_val),
                result,
                mul_enabled,
                part_num,
              )
            char_result, _ -> {
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
        SecondNum(left_val, right_digits) ->
          case string.first(input), int.parse(right_digits) {
            Ok(")"), Ok(right_val) ->
              rec(
                string.drop_start(input, 1),
                Idle,
                result + left_val * right_val,
                mul_enabled,
                part_num,
              )
            char_result, _ -> {
              case
                char_result
                |> option.from_result
                |> option.unwrap("")
                |> int.parse
              {
                Ok(digit) ->
                  rec(
                    string.drop_start(input, 1),
                    SecondNum(left_val, right_digits <> int.to_string(digit)),
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
