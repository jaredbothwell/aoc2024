import days/day8
import gleeunit/should
import utils

const example_input = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

const example_input2 = "T....#....
...T......
.T....#...
.........#
..#.......
..........
...#......
..........
....#.....
.........."

pub fn day8_part1_test() {
  utils.read_input("day8")
  |> day8.parse_input()
  |> day8.part1()
  |> should.equal("303")
}

pub fn day8_part1_ex1_test() {
  example_input
  |> day8.parse_input()
  |> day8.part1
  |> should.equal("14")
}

pub fn day8_part2_test() {
  utils.read_input("day8")
  |> day8.parse_input()
  |> day8.part2()
  |> should.equal("1045")
}

pub fn day8_part2_ex1_test() {
  example_input2
  |> day8.parse_input
  |> day8.part2
  |> should.equal("9")
}
