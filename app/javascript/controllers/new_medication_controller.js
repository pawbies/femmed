import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-medication"
export default class extends Controller {
  static targets = ["rpSelect", "rpDelayField", "rpDurationField"]

  connect() {
    this.update()
  }

  update() {
    const selected = this.rpSelectTarget.value

    if (selected === "bimodal") {
      this.rpDelayFieldTarget.classList.remove("js:hidden")
      this.rpDurationFieldTarget.classList.add("js:hidden")
    } else if (selected === "extended") {
      this.rpDelayFieldTarget.classList.add("js:hidden")
      this.rpDurationFieldTarget.classList.remove("js:hidden")
    } else {
      this.rpDelayFieldTarget.classList.add("js:hidden")
      this.rpDurationFieldTarget.classList.add("js:hidden")
    }
  }
}
