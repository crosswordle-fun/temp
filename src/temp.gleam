import externals
import gleam/list
import gleam/string
import lustre
import msg
import view
import wordle

pub fn main() {
  let app = lustre.simple(wordle.init_model, msg.update, view.view)
  let assert Ok(runtime) = lustre.start(app, "#app", Nil)

  externals.on_keypress(fn(key) { handle_key(key, runtime) })
}

fn handle_key(key: String, runtime: lustre.Runtime(msg.Msg)) -> Nil {
  let lowercased_key = key |> string.lowercase
  case lowercased_key {
    "enter" ->
      msg.PlayerSubmitWordle
      |> lustre.dispatch
      |> lustre.send(to: runtime)
    "backspace" ->
      msg.PlayerRemoveLetter
      |> lustre.dispatch
      |> lustre.send(to: runtime)
    letter ->
      case
        "abcdefghijklmnopqrstuvwxyz"
        |> string.to_graphemes
        |> list.contains(lowercased_key)
      {
        False -> Nil
        True ->
          msg.PlayerAddLetter(letter)
          |> lustre.dispatch
          |> lustre.send(to: runtime)
      }
  }
}
