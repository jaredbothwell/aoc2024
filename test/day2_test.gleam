import day2
import gleeunit/should

const input = [
  [7, 6, 4, 2, 1], [1, 2, 7, 8, 9], [9, 7, 6, 2, 1], [1, 3, 2, 4, 5],
  [8, 6, 4, 4, 1], [1, 3, 6, 7, 9],
]

pub fn day1_part1_test() {
  day2.part1(day2.parse_input())
  |> should.equal(411)
}

pub fn day2_part1_ex1_test() {
  day2.part1(input)
  |> should.equal(2)
}

pub fn day1_part2_test() {
  day2.part2(day2.parse_input())
  |> should.equal(465)
}

pub fn day1_part2_ex1_test() {
  day2.part2(input)
  |> should.equal(4)
}
