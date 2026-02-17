import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assistent"
export default class extends Controller {
  static values = {
    text: String
  }

  connect() {
    let veil = document.getElementById("veil")
    veil.classList.remove("hidden")

    veil.innerHTML = this.element.innerHTML
  }
}
