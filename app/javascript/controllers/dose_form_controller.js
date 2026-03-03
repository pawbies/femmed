import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dose-form"
export default class extends Controller {
  static targets = ["input", "output"]

  static values = {
    ingredientDosesPerUnit: Array
  }

  connect() {
    if (this.inputTarget.value) this.updateOutput()

    console.log(this.ingredientDosesPerUnitValue)
  }

  updateOutput() {
    const items = this.ingredientDosesPerUnitValue.map(data => {
      const strength = data.amount * this.inputTarget.value
      return `<li>~ ${strength}${data.unit} ${data.name}</li>`
    }).join("")

    this.outputTarget.innerHTML = `<ol>${items}</ol>`
  }
}
