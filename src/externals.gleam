@external(javascript, "./js_ffi.mjs", "on_letter_keypress")
pub fn on_letter_keypress(callback: fn(String) -> Nil) -> Nil
