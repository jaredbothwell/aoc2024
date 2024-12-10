import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import utils

type Input =
  List(Int)

pub fn solve() -> Nil {
  let input =
    utils.read_input("day9")
    |> parse_input
  io.println("Day 9:")
  io.println("  Part 1: " <> part1(input))
  io.println("  Part 2: " <> part2(input))
}

pub fn parse_input(input: String) -> Input {
  input
  |> string.trim()
  |> string.split("")
  |> list.map(fn(x) { int.parse(x) |> option.from_result })
  |> option.all
  |> option.unwrap([])
}

pub fn part1(input: Input) -> String {
  let expanded_blocks = expand(input)
  let reversed_used_blocks =
    expanded_blocks |> list.reverse |> list.filter(fn(x) { x != "." })
  let used_block_count = reversed_used_blocks |> list.length
  let filled_blocks =
    fill_space(expanded_blocks, reversed_used_blocks)
    |> list.take(used_block_count)

  filled_blocks
  |> list.map(fn(x) { int.parse(x) |> option.from_result |> option.unwrap(0) })
  |> list.index_fold(0, fn(acc, x, i) { acc + x * i })
  |> int.to_string
}

pub fn part2(input: Input) -> String {
  todo
}

fn expand(blocks: List(Int)) -> List(String) {
  rec_expand(0, blocks, False)
}

fn rec_expand(
  id: Int,
  remaining_blocks: List(Int),
  is_free_space: Bool,
) -> List(String) {
  case remaining_blocks {
    [block_size, ..rest] -> {
      let expanded_blocks = case is_free_space {
        False -> list.repeat(int.to_string(id), block_size)
        True -> list.repeat(".", block_size)
      }
      case is_free_space {
        True ->
          list.append(expanded_blocks, rec_expand(id, rest, False))
        False ->
          list.append(expanded_blocks, rec_expand(id + 1, rest, True))
      }
    }
    [] -> []
  }
}

fn fill_space(
  blocks: List(String),
  reversed_used_blocks: List(String),
) -> List(String) {
  case blocks, reversed_used_blocks {
    [".", ..rest], [next, ..] ->
      list.prepend(fill_space(rest, list.drop(reversed_used_blocks, 1)), next)
    [first, ..rest], _ ->
      list.prepend(fill_space(rest, reversed_used_blocks), first)
    [], _ -> []
  }
}
