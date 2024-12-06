import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string
import utils

type Map =
  List(List(String))

type Direction {
  Up
  Down
  Left
  Right
}

fn to_direction_vector(dir: Direction) -> DirectionVector {
  case dir {
    Up -> #(-1, 0)
    Down -> #(1, 0)
    Left -> #(0, -1)
    Right -> #(0, 1)
  }
}

type DirectionVector =
  #(Int, Int)

type Position =
  #(Int, Int)

pub fn solve() -> Nil {
  let input =
    utils.read_input("day6")
    |> parse_input
  io.println("Day 6:")
  io.println("  Part 1: " <> int.to_string(part1(input)))
  io.println("  Part 2: " <> int.to_string(part2(input)))
}

pub fn parse_input(input: String) -> Map {
  input
  |> string.split("\n")
  |> list.map(fn(row) { string.split(row, "") })
}

pub fn part1(map: Map) -> Int {
  let start = find_start(map)
  let visited = set.new() |> set.insert(start)
  let result = step(map, start, Up, visited)
  set.size(result)
}

fn step(
  map: Map,
  pos: Position,
  dir: Direction,
  visited: Set(Position),
) -> Set(Position) {
  let dir_vec = to_direction_vector(dir)
  let next_pos = #(pos.0 + dir_vec.0, pos.1 + dir_vec.1)
  let next =
    map
    |> at_index(next_pos.0)
    |> option.unwrap([])
    |> at_index(next_pos.1)

  case next {
    Some(char) -> {
      case char {
        "#" -> step(map, pos, turn(dir), visited)
        _ -> step(map, next_pos, dir, set.insert(visited, next_pos))
      }
    }
    None -> visited
  }
}

fn at_index(list: List(a), index: Int) {
  // list.drop returns whole list when using a negative index but I need an empty list instead
  let i = case index {
    x if x < 0 -> list.length(list)
    x -> x
  }

  list
  |> list.drop(i)
  |> list.first
  |> option.from_result
}

fn find_start(map: Map) -> Position {
  map
  |> list.index_fold(Error(Nil), fn(result, row, i) {
    let x =
      row
      |> list.index_fold(Error(Nil), fn(row_result, char, j) {
        case char {
          "^" -> Ok(j)
          _ -> row_result
        }
      })

    case x {
      Ok(j) -> Ok(#(i, j))
      _ -> result
    }
  })
  |> option.from_result
  |> option.unwrap(#(0, 0))
}

fn turn(dir: Direction) -> Direction {
  case dir {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

pub fn part2(map: Map) -> Int {
  let start = find_start(map)
  let pos_dir = #(start, Up)

  let original_path =
    step(map, start, Up, set.new())
    |> set.to_list

  original_path
  |> list.fold(0, fn(total_loops, obstacle_pos) {
    let #(i, j) = obstacle_pos
    let char =
      map
      |> at_index(i)
      |> option.unwrap([])
      |> at_index(j)
      |> option.unwrap("")

    total_loops
    + case char {
      "^" | "#" | "" -> 0
      _ -> {
        let visited = set.new() |> set.insert(pos_dir)
        let new_map =
          map
          |> list.index_map(fn(row, x) {
            case x == i {
              False -> row
              True ->
                list.index_map(row, fn(char, y) {
                  case y == j {
                    False -> char
                    True -> "#"
                  }
                })
            }
          })
        case step2(new_map, start, Up, visited) {
          True -> 1
          False -> 0
        }
      }
    }
  })
}

fn step2(
  map: Map,
  pos: Position,
  dir: Direction,
  visited: Set(#(Position, Direction)),
) -> Bool {
  let dir_vec = to_direction_vector(dir)
  let next_pos = #(pos.0 + dir_vec.0, pos.1 + dir_vec.1)
  let next =
    map
    |> at_index(next_pos.0)
    |> option.unwrap([])
    |> at_index(next_pos.1)

  let has_visited = set.contains(visited, #(next_pos, dir))
  case has_visited {
    True -> True
    False ->
      case next {
        Some(char) -> {
          case char {
            "#" -> step2(map, pos, turn(dir), visited)
            _ ->
              step2(map, next_pos, dir, set.insert(visited, #(next_pos, dir)))
          }
        }
        None -> False
      }
  }
}
