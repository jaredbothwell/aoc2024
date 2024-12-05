import days/day4
import gleam/list
import gleam/string
import gleeunit/should

const example_input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

pub fn day4_part1_test() {
  day4.part1(day4.parse_input())
  |> should.equal(2633)
}

pub fn day4_part1_ex1_test() {
  example_input
  |> string.split("\n")
  |> list.map(fn(line) { string.split(line, "") })
  |> day4.part1
  |> should.equal(18)
}

pub fn day4_part2_test() {
  day4.part2(day4.parse_input())
  |> should.equal(1936)
}

pub fn day4_part2_ex1_test() {
  example_input
  |> string.split("\n")
  |> list.map(fn(line) { string.split(line, "") })
  |> day4.part2
  |> should.equal(9)
}
