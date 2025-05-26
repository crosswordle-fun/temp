import externals
import lustre
import msg
import view
import wordle

pub fn main() {
  let app = lustre.simple(wordle.init_wordle, msg.update, view.view)
  let assert Ok(runtime) = lustre.start(app, "#app", Nil)

  externals.on_letter_keypress(fn(key) {
    key |> msg.PlayerAddLetter |> lustre.dispatch |> lustre.send(to: runtime)
  })

  Nil
}
