import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn solve() -> Nil {
  let input = parse_input()
  io.println("Day 2:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() -> List(List(Int)) {
  utils.read_input("day2")
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.map(fn(x) {
      int.parse(x) |> option.from_result |> option.unwrap(or: 0)
    })
  })
}

pub fn part1(input: List(List(Int))) -> Int {
  list.map(input, is_report_safe)
  |> count_safe_reports()
}

pub fn part2(input: List(List(Int))) -> Int {
  list.map(input, fn(report) {
    is_report_safe(report) || is_report_within_tolerance(report)
  })
  |> count_safe_reports()
}

fn get_report_diffs(report: List(Int)) -> List(Int) {
  list.zip(report, list.drop(report, 1))
  |> list.fold([], fn(acc, val) { list.append(acc, [val.1 - val.0]) })
}

fn is_report_value_safe(is_increasing: Bool) -> fn(Int) -> Bool {
  fn(x) {
    int.absolute_value(x) <= 3
    && int.absolute_value(x) >= 1
    && case is_increasing {
      True -> x > 0
      False -> x < 0
    }
  }
}

fn is_report_safe(report: List(Int)) -> Bool {
  let diffs = get_report_diffs(report)

  list.all(diffs, is_report_value_safe(True))
  || list.all(diffs, is_report_value_safe(False))
}

fn count_safe_reports(reports: List(Bool)) -> Int {
  list.fold(reports, 0, fn(count, is_safe) {
    case is_safe {
      True -> count + 1
      False -> count
    }
  })
}

fn is_report_within_tolerance(report: List(Int)) -> Bool {
  list.index_fold(report, False, fn(is_safe_yet, _value, index) {
    case is_safe_yet {
      True -> True
      False -> {
        let #(a, b) = list.split(report, index)
        let spliced_report = list.append(a, list.drop(b, 1))
        is_report_safe(spliced_report)
      }
    }
  })
}
