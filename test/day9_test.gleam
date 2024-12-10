import days/day9
import gleeunit/should
import utils

const example_input = "2333133121414131402"

// pub fn day9_part1_test() {
//   utils.read_input("day9")
//   |> day9.parse_input()
//   |> day9.part1()
//   |> should.equal("")
// }

pub fn day9_part1_ex1_test() {
  example_input
  |> day9.parse_input()
  |> day9.part1
  |> should.equal("6288707484810")
}
// pub fn day9_part2_test() {
//   utils.read_input("day9")
//   |> day9.parse_input()
//   |> day9.part2()
//   |> should.equal("")
// }

// pub fn day9_part2_ex1_test() {
//   example_input
//   |> day9.parse_input
//   |> day9.part2
//   |> should.equal("2858")
// }
