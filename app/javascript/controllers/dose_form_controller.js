import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dose-form"
export default class extends Controller {
  static targets = ["input", "output"]
  static values = {
    unit: String,
    strengthPerDose: Number
  }

  connect() {
    if (this.inputTarget.value) this.updateOutput()
  }

  updateOutput() {
    const strength = this.inputTarget.value * this.strengthPerDoseValue
    console.lo
    this.outputTarget.textContent = `~ ${strength}${this.unitValue}`
  }
}
