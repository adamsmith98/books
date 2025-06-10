import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  connect() {
    const dark_mode = localStorage.getItem("dark")
    if (dark_mode == "true") {
      document.body.classList.toggle("dark", true)
    }
  }

  toggle() {
    document.body.classList.toggle("dark")
    if (document.body.classList.contains("dark")) {
      localStorage.setItem("dark", "true")
    } else {
      localStorage.setItem("dark", "false")
    }
  }
}
