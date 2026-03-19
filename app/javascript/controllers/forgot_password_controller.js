import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forgot-password"
export default class extends Controller {
  static targets = ["area"]

  toggle() {
    this.areaTarget.classList.toggle("hidden")
  }
}
