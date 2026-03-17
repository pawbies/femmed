import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="live-search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.timer = null
    this.form = this.inputTarget.form
    this.url = new URL(this.form.action)
  }

  search() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.url.searchParams.set("query", this.inputTarget.value)

      fetch(this.url, {
        headers: { "Accept": "text/vnd.turbo-stream.html" }
      })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
    }, 300)
  }
}
