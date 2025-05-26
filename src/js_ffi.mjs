export function on_letter_keypress(callback) {
  window.addEventListener('keydown', function(event) {
    if (/^[a-z]$/i.test(event.key)) {
      console.log("Letter typed:", event.key);
      callback(event.key)
    }
  });
}
