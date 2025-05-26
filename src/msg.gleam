import wordle.{type Wordle, Wordle}

pub type Msg {
  PlayerStartGame
  PlayerAddLetter(letter: String)
  PlayerRemoveLetter
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
  }
}
