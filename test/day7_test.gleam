import days/day7
import gleeunit/should
import utils

const example_input = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

pub fn day7_part1_test() {
  utils.read_input("day7")
  |> day7.parse_input()
  |> day7.part1()
  |> should.equal(303_766_880_536)
}

pub fn day7_part1_ex1_test() {
  example_input
  |> day7.parse_input()
  |> day7.part1
  |> should.equal(3749)
}

pub fn day7_part2_test() {
  utils.read_input("day7")
  |> day7.parse_input()
  |> day7.part2()
  |> should.equal(337_041_851_384_440)
}

pub fn day7_part2_ex1_test() {
  example_input
  |> day7.parse_input
  |> day7.part2
  |> should.equal(11_387)
}
