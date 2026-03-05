import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-medication"
export default class extends Controller {
  static targets = ["rpSelect", "rpDelayField", "rpDurationField"]

  connect() {
    this.update()
  }

  update() {
    const selected = this.rpSelectTarget.options[this.rpSelectTarget.selectedIndex]?.text

    if (selected === "Bimodal") {
      this.rpDelayFieldTarget.classList.remove("js:hidden")
      this.rpDurationFieldTarget.classList.add("js:hidden")
    } else if (selected === "Extended") {
      this.rpDelayFieldTarget.classList.add("js:hidden")
      this.rpDurationFieldTarget.classList.remove("js:hidden")
    } else {
      this.rpDelayFieldTarget.classList.add("js:hidden")
      this.rpDurationFieldTarget.classList.add("js:hidden")
    }
  }
}
