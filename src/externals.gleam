@external(javascript, "./js_ffi.mjs", "on_keypress")
pub fn on_keypress(callback: fn(String) -> Nil) -> Nil
