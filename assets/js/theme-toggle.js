(function() {
  var root = document.documentElement;
  var toggle = document.querySelector("#theme-toggle");

  if (!toggle) {
    return;
  }

  function isDark() {
    return root.classList.contains("theme-dark");
  }

  function setTheme(theme) {
    var dark = theme === "dark";
    root.classList.toggle("theme-dark", dark);
    root.style.colorScheme = dark ? "dark" : "light";
    toggle.setAttribute("aria-checked", String(dark));
    toggle.title = dark ? "Switch to light mode" : "Switch to dark mode";

    try {
      localStorage.setItem("theme", theme);
    } catch (error) {
      return;
    }
  }

  function toggleTheme() {
    setTheme(isDark() ? "light" : "dark");
  }

  toggle.addEventListener("click", toggleTheme);

  window.addEventListener("keydown", function(event) {
    var active = document.activeElement;
    var isTyping = active && ["INPUT", "TEXTAREA", "SELECT"].indexOf(active.tagName) !== -1;

    if (isTyping || event.ctrlKey || event.metaKey || event.altKey) {
      return;
    }

    if (event.key === "d" || event.key === "D") {
      toggleTheme();
    }
  });

  toggle.setAttribute("aria-checked", String(isDark()));
  toggle.title = isDark() ? "Switch to light mode" : "Switch to dark mode";
})();

