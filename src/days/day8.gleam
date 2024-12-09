import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string
import utils

type Input =
  List(List(String))

type Vector {
  Vector(x: Int, y: Int)
}

type Position {
  Position(x: Int, y: Int)
}

pub fn solve() -> Nil {
  let input =
    utils.read_input("day8")
    |> parse_input
  io.println("Day 8:")
  io.println("  Part 1: " <> part1(input))
  io.println("  Part 2: " <> part2(input))
}

pub fn parse_input(input: String) -> Input {
  input
  |> string.split("\n")
  |> list.map(fn(line) { string.split(line, "") })
}

pub fn part1(input: Input) -> String {
  let height = list.length(input)
  let width = case input {
    [] -> 0
    [first, ..] -> list.length(first)
  }

  input
  |> get_antenna_dict
  |> dict.to_list
  |> list.fold(set.new(), fn(acc, data) {
    list.combination_pairs(data.1)
    |> get_antinodes(height, width)
    |> set.union(acc)
  })
  |> set.size
  |> int.to_string
}

pub fn part2(input: Input) -> String {
  let height = list.length(input)
  let width = case input {
    [] -> 0
    [first, ..] -> list.length(first)
  }

  input
  |> get_antenna_dict
  |> dict.to_list
  |> list.fold(set.new(), fn(acc, data) {
    list.combination_pairs(data.1)
    |> get_antinodes2(height, width)
    |> set.union(acc)
  })
  |> set.size
  |> int.to_string
}

fn get_antenna_dict(input: Input) -> Dict(String, List(Position)) {
  input
  |> list.index_fold([], fn(acc, row, y) {
    list.index_fold(row, [], fn(a, char, x) {
      list.append(a, [#(char, Position(x, y))])
    })
    |> list.append(acc)
  })
  |> list.fold(dict.new(), fn(d, data) {
    case data.0 {
      "." | "#" -> d
      _ ->
        dict.upsert(d, data.0, fn(x) {
          case x {
            Some(l) -> list.append(l, [data.1])
            None -> [data.1]
          }
        })
    }
  })
}

fn get_antinodes(
  antenna_pairs: List(#(Position, Position)),
  height: Int,
  width: Int,
) -> Set(Position) {
  antenna_pairs
  |> list.fold(set.new(), fn(acc, antenna_pair) {
    let #(a, b) = case antenna_pair {
      #(a, b) if a.x > b.x -> #(b, a)
      pair -> pair
    }
    let dx = b.x - a.x
    let dy = b.y - a.y

    let anti_1 = Position(a.x - dx, a.y - dy)
    let anti_2 = Position(b.x + dx, b.y + dy)

    let temp_set = case anti_1 {
      Position(x, y) if x >= 0 && y >= 0 && x < width && y < height ->
        set.insert(acc, anti_1)
      _ -> acc
    }

    case anti_2 {
      Position(x, y) if x >= 0 && y >= 0 && x < width && y < height ->
        set.insert(temp_set, anti_2)
      _ -> temp_set
    }
  })
}

fn get_antinodes2(
  antenna_pairs: List(#(Position, Position)),
  height: Int,
  width: Int,
) -> Set(Position) {
  antenna_pairs
  |> list.fold(set.new(), fn(acc, antenna_pair) {
    let #(a, b) = case antenna_pair {
      #(a, b) if a.x > b.x -> #(b, a)
      pair -> pair
    }
    let dx = b.x - a.x
    let dy = b.y - a.y

    let forward = waves(a, [], Vector(dx, dy), height, width)
    let backward = waves(b, [], Vector(dx * -1, dy * -1), height, width)

    set.union(acc, set.union(set.from_list(forward), set.from_list(backward)))
  })
}

fn waves(
  pos: Position,
  nodes: List(Position),
  vector: Vector,
  height,
  width,
) -> List(Position) {
  case pos {
    Position(x, y) if x >= 0 && y >= 0 && x < width && y < height ->
      waves(
        Position(x + vector.x, y + vector.y),
        list.append(nodes, [pos]),
        vector,
        height,
        width,
      )
    _ -> nodes
  }
}
