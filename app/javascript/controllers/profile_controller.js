import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile"
export default class extends Controller {
  static targets = ["popup"]

  toggle() {
    this.popupTarget.classList.toggle("hidden")
  }
}
