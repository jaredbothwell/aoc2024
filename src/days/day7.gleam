import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import utils

type Input =
  List(Equation)

pub type Equation {
  Equation(test_value: Int, numbers: List(Int))
}

pub type Operator =
  fn(Int, Int) -> Int

pub fn solve() -> Nil {
  let input =
    utils.read_input("day7")
    |> parse_input
  io.println("Day 7:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input(input: String) -> Input {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    case string.split_once(line, ": ") {
      Ok(#(x, rest)) -> {
        let nums =
          rest
          |> string.split(" ")
          |> list.map(fn(num) { int.parse(num) })
          |> result.all
          |> option.from_result
          |> option.unwrap([])

        case int.parse(x) {
          Ok(test_value) -> Some(Equation(test_value, nums))
          _ -> None
        }
      }
      _ -> None
    }
  })
  |> option.all
  |> option.unwrap([])
}

pub fn part1(input: Input) -> Int {
  let operators = [add, mult]
  input
  |> list.filter(fn(equation) { is_equation_possible(equation, operators) })
  |> list.fold(0, fn(acc, equation) { acc + equation.test_value })
}

pub fn part2(input: Input) -> Int {
  let operators = [add, mult, concat]
  input
  |> list.filter(fn(equation) { is_equation_possible(equation, operators) })
  |> list.fold(0, fn(acc, equation) { acc + equation.test_value })
}

fn is_equation_possible(equation: Equation, operators: List(Operator)) {
  case equation.numbers {
    [first, ..rest] -> try_eval(first, rest, equation.test_value, operators)
    [] -> False
  }
}

fn try_eval(
  curr: Int,
  nums: List(Int),
  target: Int,
  operators: List(Operator),
) -> Bool {
  case nums {
    [] -> curr == target
    [next, ..rest] -> {
      curr <= target
      && list.fold(operators, False, fn(any, operator) {
        any || try_eval(operator(curr, next), rest, target, operators)
      })
    }
  }
}

fn add(a: Int, b: Int) -> Int {
  a + b
}

fn mult(a: Int, b: Int) -> Int {
  a * b
}

fn concat(a: Int, b: Int) -> Int {
  let assert Ok(num) = int.parse(int.to_string(a) <> int.to_string(b))
  num
}
