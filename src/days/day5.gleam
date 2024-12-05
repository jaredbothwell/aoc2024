import gleam/int
import gleam/io
import utils

pub fn solve() -> Nil {
  let input = parse_input()
  io.println("Day 3:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input() {
  utils.read_input("day5")
}

pub fn part1(_input) -> Int {
  0
}

pub fn part2(_input) -> Int {
  0
}
