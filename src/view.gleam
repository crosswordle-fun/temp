import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element/html
import lustre/event
import msg
import wordle.{type Attempt, type Progress, type Wordle}

pub fn view(model: Wordle) {
  html.body(
    [
      attribute.class(
        "min-h-screen bg-white flex flex-col items-center place-content-between",
      ),
    ],
    [
      html.div([attribute.class("flex flex-col items-center")], [
        title_view(),
        level_view(model.level),
      ]),
      html.div([attribute.class("bg-white flex flex-col items-center px-2")], [
        attempts_view(model.attempts),
        guess_view(model),
      ]),
      keyboard_view(),
    ],
  )
}

fn title_view() {
  html.header([attribute.class("w-full pb-3 pt-5 border-b border-black mb-3")], [
    html.h1(
      [
        attribute.class(
          "text-center text-4xl sm:text-5xl font-semibold text-black tracking-[0.15em] uppercase",
        ),
      ],
      [html.text("CROSSWORDLE")],
    ),
  ])
}

fn level_view(level: Int) {
  html.div(
    [attribute.class("inline-block bg-black text-white px-3 py-1 rounded-full")],
    [
      html.p(
        [
          attribute.class(
            "text-xs sm:text-sm font-semibold uppercase tracking-wide",
          ),
        ],
        [
          html.text(" LVL "),
          html.span([attribute.class("font-bold")], [
            html.text(level |> int.to_string),
          ]),
        ],
      ),
    ],
  )
}

fn attempts_view(attempts: List(Attempt)) {
  html.div(
    [
      attribute.class(
        "flex flex-col justify-center items-center py-4 px-4 gap-1 bg-white",
      ),
    ],
    attempts
      |> list.map(fn(attempt) { tiles_view(attempt.word, attempt.progress) }),
  )
}

fn guess_view(model: Wordle) {
  html.div([attribute.class("flex justify-center py-4 bg-white")], [
    tiles_view(model.guess, model.progress),
  ])
}

fn tiles_view(guess: List(String), progress: List(Progress)) {
  let progress_colors =
    progress
    |> list.map(progress_to_color)
  html.div(
    [attribute.class("flex grid grid-cols-5 gap-1")],
    guess |> list.map2(progress_colors, single_tile),
  )
}

fn single_tile(letter: String, progress_color: String) {
  html.div(
    [
      attribute.class(
        "w-14 h-14 sm:w-16 sm:h-16 border border-black flex items-center justify-center text-3xl font-bold uppercase text-black "
        <> progress_color,
      ),
    ],
    [html.text(letter)],
  )
}

fn keyboard_view() {
  html.div(
    [
      attribute.class(
        "w-full max-w-xs sm:max-w-sm flex flex-col items-center gap-1 p-1 sm:p-2 border border-black",
      ),
    ],
    [row_1_view(), row_2_view(), row_3_view()],
  )
}

fn row_1_view() {
  "qwertyuiop"
  |> string.to_graphemes
  |> list.map(key_view)
  |> html.div(
    [attribute.class("flex justify-center w-full gap-x-1 sm:gap-x-1.5")],
    _,
  )
}

fn row_2_view() {
  "asdfghjkl"
  |> string.to_graphemes
  |> list.map(key_view)
  |> html.div(
    [attribute.class("flex justify-center w-full gap-x-1 sm:gap-x-1.5")],
    _,
  )
}

fn row_3_view() {
  "zxcvbnm"
  |> string.to_graphemes
  |> list.map(key_view)
  |> list.append([enter_key_view()])
  |> list.prepend(delete_key_view())
  |> html.div(
    [attribute.class("flex justify-center w-full gap-x-1 sm:gap-x-1.5")],
    _,
  )
}

fn key_view(single_key: String) {
  html.button(
    [
      event.on_click(msg.PlayerAddLetter(single_key)),
      attribute.class(
        "
        min-w-[2rem]    <!-- Minimum width (32px) - can be adjusted -->
        h-11            <!-- Height (44px) - common tap target height -->
        px-2            <!-- Horizontal padding (8px) -->
        bg-white
        text-black
        border border-black
        rounded         <!-- Slightly less rounded corners -->
        flex items-center justify-center
        text-sm sm:text-base font-medium  <!-- Smaller font size -->
        uppercase
        hover:bg-neutral-100
        active:bg-neutral-200
    ",
      ),
    ],
    [html.text(single_key)],
  )
}

fn enter_key_view() {
  html.button(
    [
      event.on_click(msg.PlayerSubmitWordle),
      attribute.class(
        "
        
        h-11
        px-2
        bg-black
        text-white
        border border-black
        rounded
        flex items-center justify-center
        text-xs sm:text-sm font-semibold
        uppercase
        hover:bg-neutral-800
        active:bg-neutral-700
    ",
      ),
    ],
    [html.text("ENTER")],
  )
}

fn delete_key_view() {
  html.button(
    [
      event.on_click(msg.PlayerRemoveLetter),
      attribute.class(
        "
        flex-grow
        h-11
        px-2
        bg-black
        text-white
        border border-black
        rounded
        flex items-center justify-center
        text-xs sm:text-sm font-semibold
        uppercase
        hover:bg-neutral-800
        active:bg-neutral-700
    ",
      ),
    ],
    [html.text("DEL")],
  )
}

fn progress_to_color(progress: Progress) -> String {
  case progress {
    wordle.NotSet -> "bg-white"
    wordle.Absent -> "bg-gray-300"
    wordle.Present -> "bg-yellow-400"
    wordle.Correct -> "bg-green-400"
  }
}
