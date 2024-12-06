import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import utils

type Input =
  Result(#(List(#(Int, Int)), List(List(Int))), Nil)

pub fn solve() -> Nil {
  let input =
    utils.read_input("day5")
    |> parse_input
  io.println("Day 5:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input(input: String) -> Input {
  case string.split(input, "\n\n") {
    [top_half, bottom_half] -> {
      let top_result =
        top_half
        |> string.split("\n")
        |> list.map(fn(line) {
          case string.split(line, "|") {
            [a, b] -> {
              case int.parse(a), int.parse(b) {
                Ok(x), Ok(y) -> Ok(#(x, y))
                _, _ -> Error(Nil)
              }
            }
            _ -> Error(Nil)
          }
        })
        |> result.all

      let bottom_result =
        bottom_half
        |> string.split("\n")
        |> list.map(fn(line) {
          line
          |> string.split(",")
          |> list.map(int.parse)
          |> result.all
        })
        |> result.all

      case top_result, bottom_result {
        Ok(pairs), Ok(lists) -> Ok(#(pairs, lists))
        _, _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn part1(input: Input) -> Int {
  case input {
    Error(_) -> 0
    Ok(#(top, bottom)) -> {
      let rule_dict = get_rule_dict(top)

      bottom
      |> list.filter(fn(update) { is_valid(rule_dict, update) })
      |> list.fold([], fn(acc, x) {
        let mid_index = case int.divide(list.length(x), 2) {
          Ok(y) -> y
          _ -> 0
        }
        let value = utils.at_index(x, mid_index, 0)
        list.append(acc, [value])
      })
      |> list.fold(0, fn(acc, x) { acc + x })
    }
  }
}

pub fn part2(input: Input) -> Int {
  case input {
    Error(_) -> 0
    Ok(#(top, bottom)) -> {
      let rule_dict = get_rule_dict(top)

      bottom
      |> list.filter(fn(update) { !is_valid(rule_dict, update) })
      |> list.map(fn(x) { fix_order(rule_dict, x) })
      |> list.fold(0, fn(acc, x) {
        let mid_index = case int.divide(list.length(x), 2) {
          Ok(i) -> i
          _ -> 0
        }
        acc + utils.at_index(x, mid_index, 0)
      })
    }
  }
}

fn is_valid(rules: Dict(Int, List(Int)), updates: List(Int)) -> Bool {
  rec_is_valid(rules, set.new(), updates)
}

fn rec_is_valid(
  rule_dict: Dict(Int, List(Int)),
  visited: Set(Int),
  updates: List(Int),
) {
  case list.first(updates) {
    Error(_) -> True
    Ok(x) -> {
      case dict.get(rule_dict, x) {
        // No rule for this number - keep checking 
        Error(_) ->
          rec_is_valid(rule_dict, set.insert(visited, x), list.drop(updates, 1))

        // Check rules for this number
        Ok(before_nums) ->
          case list.any(before_nums, fn(num) { set.contains(visited, num) }) {
            // Already seen a number that should be after current number - not valid
            True -> False
            // Possibly valid - check next number
            False ->
              rec_is_valid(
                rule_dict,
                set.insert(visited, x),
                list.drop(updates, 1),
              )
          }
      }
    }
  }
}

fn get_rule_dict(rules: List(#(Int, Int))) -> Dict(Int, List(Int)) {
  list.fold(rules, dict.new(), fn(dict, rule) {
    dict.upsert(dict, rule.0, fn(existing_values) {
      case existing_values {
        Some(x) -> list.append(x, [rule.1])
        None -> [rule.1]
      }
    })
  })
}

fn fix_order(rules: Dict(Int, List(Int)), update: List(Int)) -> List(Int) {
  list.fold(update, [], fn(acc, x) { rec_fix_order(rules, acc, x, 0) })
}

fn rec_fix_order(
  rules: Dict(Int, List(Int)),
  update: List(Int),
  curr_val: Int,
  index: Int,
) -> List(Int) {
  let #(left, right) = list.split(update, index)
  let test_update = list.flatten([left, list.prepend(right, curr_val)])

  case is_valid(rules, test_update) {
    True -> test_update
    False -> rec_fix_order(rules, update, curr_val, index + 1)
  }
}
