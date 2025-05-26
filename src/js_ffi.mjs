export function on_keypress(callback) {
  window.addEventListener('keydown', function(event) {
    callback(event.key)
  });
}
