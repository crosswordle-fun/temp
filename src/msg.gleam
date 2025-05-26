import wordle.{type Wordle}

pub type Msg {
  PlayerStartGame
}

pub fn update(model: Wordle, msg: Msg) -> Wordle {
  case msg {
    PlayerStartGame -> model
  }
}
