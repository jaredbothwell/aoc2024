import days/day3
import gleeunit/should

const example_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
const example_input2 = "mul(4*, mul(6,9!, ?(12,34), or mul ( 2 , 4 ) "
const example_input3 = "mul(1,2)mul(3,4)"

pub fn day3_part1_test() {
  day3.part1(day3.parse_input())
  |> should.equal(175_615_763)
}

pub fn day3_part1_ex1_test() {
  day3.part1(example_input)
  |> should.equal(161)
}

pub fn day3_part1_ex2_test() {
  day3.part1(example_input2)
  |> should.equal(0)
}

pub fn day3_part1_ex3_test() {
  day3.part1(example_input3)
  |> should.equal(14)
}

pub fn day3_part2_test() {
  day3.part2(day3.parse_input())
  |> should.equal(74_361_272)
}

pub fn day3_part2_ex1_test() {
  day3.part2(example_input)
  |> should.equal(48)
}
