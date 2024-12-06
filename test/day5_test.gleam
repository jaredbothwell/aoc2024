import days/day5
import gleeunit/should

const example_input = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

// pub fn day5_part1_test() {
//   utils.read_input("day5")
//   |> string.join("\n")
//   |> day5.parse_input()
//   |> day5.part1()
//   |> should.equal(4957)
// }

pub fn day5_part1_ex1_test() {
  example_input
  |> day5.parse_input()
  |> day5.part1
  |> should.equal(143)
}

// pub fn day5_part2_test() {
//   utils.read_input("day5")
//   |> string.join("\n")
//   |> day5.parse_input()
//   |> day5.part2()
//   |> should.equal(6938)
// }

pub fn day5_part2_ex1_test() {
  example_input
  |> day5.parse_input
  |> day5.part2
  |> should.equal(123)
}
