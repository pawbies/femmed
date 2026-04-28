import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lab-result-form"
export default class extends Controller {
  static targets = ["unit", "rangeHint", "rangeMin", "rangeMax", "noRange", "valueField"]
  static values  = { markers: Array }

  connect() {
    // Trigger on load in case the select already has a value (e.g. form re-render on error)
    this.update()
  }

  update() {
    const select  = this.element.querySelector("select[name$='[bio_marker_id]']")
    const id      = parseInt(select?.value)
    const marker  = this.markersValue.find(m => m.id === id)

    if (!marker) {
      this.unitTarget.textContent    = ""
      this.rangeHintTarget.classList.add("hidden")
      return
    }

    this.unitTarget.textContent = marker.unit

    if (marker.min != null && marker.max != null) {
      this.rangeMinTarget.textContent = marker.min
      this.rangeMaxTarget.textContent = marker.max
      this.noRangeTarget.classList.add("hidden")
      this.rangeMinTarget.closest("[data-range-values]").classList.remove("hidden")
    } else {
      this.noRangeTarget.classList.remove("hidden")
      this.rangeMinTarget.closest("[data-range-values]").classList.add("hidden")
    }

    this.rangeHintTarget.classList.remove("hidden")
  }
}
