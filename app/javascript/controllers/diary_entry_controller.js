import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="diary-entry"
export default class extends Controller {
  static targets = ["newSideEffect", "newSideEffectButton", "cancelNewSideEffectButton"]

  showNewSideEffect() {
    this.newSideEffectTarget.classList.remove("hidden")
    this.newSideEffectButtonTarget.classList.add("hidden")
    this.cancelNewSideEffectButtonTarget.classList.remove("hidden")
  }

  cancelNewSideEffect() {
    this.newSideEffectTarget.classList.add("hidden")
    this.newSideEffectButtonTarget.classList.remove("hidden")
    this.cancelNewSideEffectButtonTarget.classList.add("hidden")
  }
}
