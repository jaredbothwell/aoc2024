import day1
import gleeunit/should

pub fn day1_part1_test() {
  day1.part1(day1.parse_input())
  |> should.equal(2_285_373)
}

pub fn day1_part2_test() {
  day1.part2(day1.parse_input())
  |> should.equal(21_142_653)
}
