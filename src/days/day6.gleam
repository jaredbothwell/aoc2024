import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
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
    Up -> DirectionVector(0, -1)
    Down -> DirectionVector(0, 1)
    Left -> DirectionVector(-1, 0)
    Right -> DirectionVector(1, 0)
  }
}

type DirectionVector {
  DirectionVector(x: Int, y: Int)
}

type Position {
  Position(x: Int, y: Int)
}

type PathState {
  PathState(position: Position, direction: Direction)
}

type MapSquare {
  MapSquare(value: Option(String), position: Position)
}

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
  case find_start(map) {
    Ok(start) -> step1(map, start, Up, set.insert(set.new(), start)) |> set.size
    _ -> 0
  }
}

pub fn part2(map: Map) -> Int {
  case find_start(map) {
    Ok(start) -> {
      step1(map, start, Up, set.new())
      |> set.to_list
      |> count_loops_after_adding_obstacle(map, start)
    }
    _ -> 0
  }
}

fn step1(
  map: Map,
  pos: Position,
  dir: Direction,
  visited: Set(Position),
) -> Set(Position) {
  let next = next_map_square(map, pos, dir)
  case next.value {
    None -> visited
    Some("#") -> step1(map, pos, turn_right(dir), visited)
    _ -> step1(map, next.position, dir, set.insert(visited, next.position))
  }
}

fn step2(
  map: Map,
  pos: Position,
  dir: Direction,
  visited: Set(PathState),
) -> Bool {
  let next = next_map_square(map, pos, dir)
  let has_visited = set.contains(visited, PathState(next.position, dir))
  case has_visited, next.value {
    True, _ -> True
    _, Some("#") -> step2(map, pos, turn_right(dir), visited)
    _, Some(_) -> {
      let visited = set.insert(visited, PathState(next.position, dir))
      step2(map, next.position, dir, visited)
    }
    _, None -> False
  }
}

fn turn_right(dir: Direction) -> Direction {
  case dir {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn find_start(map: Map) -> Result(Position, Nil) {
  map
  |> list.index_fold(Error(Nil), fn(result, row, y) {
    let x_result =
      row
      |> list.index_fold(Error(Nil), fn(row_result, char, x) {
        case char {
          "^" -> Ok(x)
          _ -> row_result
        }
      })

    case x_result {
      Ok(x) -> Ok(Position(x, y))
      _ -> result
    }
  })
}

fn add_obstacle(map: Map, pos: Position) -> Map {
  map
  |> list.index_map(fn(row, y) {
    case y == pos.y {
      False -> row
      True ->
        list.index_map(row, fn(char, x) {
          case x == pos.x {
            False -> char
            True -> "#"
          }
        })
    }
  })
}

fn at_index(list: List(a), index: Int) {
  list
  |> list.drop(case index {
    x if x < 0 -> list.length(list)
    x -> x
  })
  |> list.first
  |> option.from_result
}

fn at_position_in_map(map: Map, pos: Position) -> MapSquare {
  let val =
    map
    |> at_index(pos.y)
    |> option.unwrap([])
    |> at_index(pos.x)

  case val {
    None -> MapSquare(None, pos)
    v -> MapSquare(v, pos)
  }
}

fn next_map_square(map: Map, pos: Position, dir: Direction) -> MapSquare {
  let dir_vec = to_direction_vector(dir)
  at_position_in_map(map, Position(pos.x + dir_vec.x, pos.y + dir_vec.y))
}

fn count_loops_after_adding_obstacle(
  obstacle_positions: List(Position),
  map: Map,
  start: Position,
) {
  obstacle_positions
  |> list.fold(0, fn(total_loops, obstacle_pos) {
    total_loops
    + case at_position_in_map(map, obstacle_pos).value {
      Some(".") -> {
        let path_history = set.new() |> set.insert(PathState(start, Up))
        let new_map = add_obstacle(map, obstacle_pos)
        case step2(new_map, start, Up, path_history) {
          True -> 1
          False -> 0
        }
      }
      _ -> 0
    }
  })
}
