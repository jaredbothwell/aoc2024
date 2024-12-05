import days/day5
import gleeunit/should

const example_input = ""

pub fn day5_part1_test() {
  day5.part1(day5.parse_input())
  |> should.equal(0)
}

pub fn day5_part1_ex1_test() {
  example_input
  |> day5.part1
  |> should.equal(0)
}

pub fn day5_part2_test() {
  day5.part2(day5.parse_input())
  |> should.equal(0)
}

pub fn day5_part2_ex1_test() {
  example_input
  |> day5.part2
  |> should.equal(0)
}
