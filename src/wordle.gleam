import gleam/bool
import gleam/list
import gleam/string

pub type Wordle {
  Wordle(
    level: Int,
    solution: List(String),
    guess: List(String),
    progress: List(Progress),
    attempts: List(Attempt),
  )
}

pub type Progress {
  NotSet
  Absent
  Present
  Correct
}

pub type Attempt {
  Attempt(word: List(String), progress: List(Progress))
}

pub fn init_wordle(_) -> Wordle {
  let level = 1
  let solution = "cross" |> string.to_graphemes
  let guess = list.repeat("", 5)
  let progress = list.repeat(NotSet, 5)
  let attempts = []
  Wordle(level:, solution:, guess:, progress:, attempts:)
}

pub fn add_letter(word: List(String), letter: String) -> List(String) {
  case word {
    [] -> word
    ["", ..rest] -> [letter, ..rest]
    [first, ..rest] -> [first, ..add_letter(rest, letter)]
  }
}

pub fn remove_letter(word: List(String)) -> List(String) {
  // abcde
  case word {
    [] -> word
    ["", ..] -> word
    [_, "", ..rest] -> ["", "", ..rest]
    [a, _] -> [a, ""]
    [a, ..rest] -> [a, ..remove_letter(rest)]
  }
}

pub fn old_dont_use_remove_letter(word: List(String)) -> List(String) {
  case word |> list.reverse {
    [] -> word |> list.reverse
    ["", ..rest] ->
      old_dont_use_remove_letter(rest |> list.reverse) |> list.append([""])
    [_, ..rest] -> ["", ..rest] |> list.reverse
  }
}

pub fn check_progress(
  guess: List(String),
  solution: List(String),
) -> List(Progress) {
  let is_guess_5 = guess |> list.length == 5
  let is_solution_5 = guess |> list.length == 5

  case is_guess_5 && is_solution_5 {
    False -> list.repeat(NotSet, 5)
    True -> {
      let pass_1 =
        guess
        |> list.map2(solution, fn(g, s) {
          case g == s {
            False -> NotSet
            True -> Correct
          }
        })

      let pass_2 =
        guess
        |> list.map2(pass_1, fn(g, p) {
          case g, p {
            _, Correct -> Correct
            _, NotSet -> {
              case solution |> list.contains(g) {
                False -> Absent
                True -> Present
              }
            }
            _, _ -> NotSet
          }
        })

      pass_2
    }
  }
}

pub fn check_progress_with_freq(
  guess: List(String),
  solution: List(String),
) -> List(Progress) {
  let pass_1 =
    guess
    |> list.map2(solution, fn(g, s) {
      case g == s {
        False -> NotSet
        True -> Correct
      }
    })

  let #(_, pass_2) = guess |> list.map_fold(solution, check_with_freqs)

  let final_pass =
    pass_1
    |> list.map2(pass_2, fn(p1, p2) {
      case p1, p2 {
        Correct, _ -> Correct
        _, Present -> Present
        _, _ -> Absent
      }
    })

  final_pass
}

pub fn check_with_freqs(
  freq: List(String),
  letter: String,
) -> #(List(String), Progress) {
  let #(is_present_list, new_freq) =
    freq
    |> list.sort(string.compare)
    |> list.chunk(fn(x) { x })
    |> list.map(fn(chunk) {
      case chunk |> list.contains(letter) {
        False -> #(False, chunk)
        True -> #(True, chunk |> list.drop(1))
      }
    })
    |> list.unzip

  let progress = case is_present_list |> list.fold(False, bool.or) {
    False -> Absent
    True -> Present
  }

  #(new_freq |> list.flatten, progress)
}
