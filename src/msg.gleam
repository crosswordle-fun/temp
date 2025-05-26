import gleam/list
import gleam/string
import wordle.{type Wordle, Wordle}

pub type Msg {
  PlayerStartGame
  PlayerAddLetter(letter: String)
  PlayerRemoveLetter
  PlayerSubmitWordle
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
    PlayerSubmitWordle -> model |> handle_submit_wordle
  }
}

fn handle_submit_wordle(model: Wordle) {
  let guess = model.guess
  let is_full_word =
    model.guess |> list.fold("", string.append) |> string.length == 5

  case is_full_word {
    False -> model
    True -> {
      let progress = guess |> wordle.check_progress_with_freq(model.solution)

      Wordle(..model, progress:)
    }
  }
}
