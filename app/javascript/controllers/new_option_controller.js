import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-option"
export default class extends Controller {
  static targets = ["select", "field"]

  connect() {
    this.toggle()
  }

  toggle() {
    this.fieldTarget.classList.toggle("hidden", this.selectTarget.value !== "new")
  }
}
