import days/day6
import gleeunit/should

const example_input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

// pub fn day6_part1_test() {
//   utils.read_input("day6")
//   |> day6.parse_input()
//   |> day6.part1()
//   |> should.equal(5162)
// }

pub fn day6_part1_ex1_test() {
  example_input
  |> day6.parse_input()
  |> day6.part1
  |> should.equal(41)
}

// pub fn day6_part2_test() {
//   utils.read_input("day6")
//   |> day6.parse_input()
//   |> day6.part2()
//   |> should.equal(1909)
// }

pub fn day6_part2_ex1_test() {
  example_input
  |> day6.parse_input
  |> day6.part2
  |> should.equal(6)
}
