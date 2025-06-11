import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = [ "sidebar", "main" ]

  connect() {
    if (localStorage.getItem("sidebar") == "open") {
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.mainTarget.classList.remove("-ml-64")
    }
  }

  toggle() {
    localStorage.setItem("sidebar", localStorage.getItem("sidebar") == "open" ? "closed" : "open")
    this.sidebarTarget.classList.toggle("-translate-x-full")
    this.mainTarget.classList.toggle("-ml-64")
  }
}
