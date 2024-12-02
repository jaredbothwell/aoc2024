import day1
import gleeunit/should

const input = #([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3])

pub fn day1_part1_test() {
  day1.part1(day1.parse_input())
  |> should.equal(2_285_373)
}

pub fn day1_part1_ex1_test() {
  day1.part1(input)
  |> should.equal(11)
}

pub fn day1_part2_test() {
  day1.part2(day1.parse_input())
  |> should.equal(21_142_653)
}

pub fn day1_part2_ex1_test() {
  day1.part2(input)
  |> should.equal(31)
}
