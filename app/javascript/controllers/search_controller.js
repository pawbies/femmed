import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["hiddenOptions"]

  toggleHiddenOptions() {
    this.hiddenOptionsTarget.classList.toggle("js:hidden");
  }
}
