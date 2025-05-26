import lustre
import msg
import view
import wordle

pub fn main() {
  let app = lustre.simple(wordle.init_wordle, msg.update, view.view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
