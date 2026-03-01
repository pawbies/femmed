import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="medication-versions"
export default class extends Controller {
  static targets = [ "new" ]

  toggle() {
    this.newTarget.classList.toggle("hidden")
  }
}
