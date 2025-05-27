import gleam/list
import gleam/string
import wordle.{type Wordle, Correct, Wordle}

pub type Msg {
  PlayerStartGame
  PlayerAddLetter(letter: String)
  PlayerRemoveLetter
  PlayerSubmitWordle
  PlayerNextLevel
  HandleKeyPressEvent(key: String)
}

pub fn update(model: Wordle, msg: Msg) -> Wordle {
  case msg {
    PlayerStartGame -> model
    PlayerAddLetter(letter) -> {
      let new_guess = model.guess |> wordle.add_letter(letter)
      Wordle(..model, guess: new_guess)
    }
    PlayerRemoveLetter -> {
      let new_guess = model.guess |> wordle.remove_letter
      Wordle(..model, guess: new_guess)
    }
    PlayerSubmitWordle ->
      model
      |> handle_submit_wordle
      |> clear_guess_input
      |> handle_correct_guess
    PlayerNextLevel -> model |> handle_next_level
    HandleKeyPressEvent(key) -> model |> handle_key(key)
  }
}

fn handle_submit_wordle(model: Wordle) {
  let is_full_word =
    model.guess |> list.fold("", string.append) |> string.length == 5

  case is_full_word {
    False -> model
    True -> {
      let progress =
        model.guess |> wordle.check_progress_with_freq(model.solution)
      let attempts =
        model.attempts
        |> list.append(
          wordle.Attempt(word: model.guess, progress:) |> list.wrap,
        )
      echo attempts
      Wordle(..model, progress:, attempts:)
    }
  }
}

fn clear_guess_input(model: Wordle) {
  Wordle(..model, guess: list.repeat("", 5))
}

fn handle_correct_guess(model: Wordle) {
  case
    model.progress
    |> list.all(fn(p) { p == Correct })
  {
    False -> model
    True -> {
      Wordle(..model, solved: True)
    }
  }
}

fn handle_next_level(model: Wordle) {
  let level = model.level + 1
  let #(word, word_list) = model.word_list |> wordle.get_next_level_word
  let solution = word |> string.to_graphemes

  Wordle(..wordle.init_wordle(), level:, solution:, word_list:)
}

fn handle_key(model: Wordle, key: String) {
  let lowercased_key = key |> string.lowercase
  case lowercased_key {
    "enter" -> {
      case model.solved {
        False -> {
          model
          |> handle_submit_wordle
          |> clear_guess_input
          |> handle_correct_guess
        }
        True -> model |> handle_next_level
      }
    }
    "backspace" -> {
      let new_guess = model.guess |> wordle.remove_letter
      Wordle(..model, guess: new_guess)
    }
    letter -> {
      case
        "abcdefghijklmnopqrstuvwxyz"
        |> string.to_graphemes
        |> list.contains(lowercased_key)
      {
        False -> model
        True -> {
          let new_guess = model.guess |> wordle.add_letter(letter)
          Wordle(..model, guess: new_guess)
        }
      }
    }
  }
}
