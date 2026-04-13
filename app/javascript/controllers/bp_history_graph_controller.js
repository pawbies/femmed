import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="bp-history-graph"
export default class extends Controller {
  static targets = ["chart"]
  static values = { sys: Array, dia: Array, bpm: Array, medications: Array }

  connect() {
    console.log(this.sysValue, this.diaValue, this.bpmValue, this.medicationsValue)
  }
}
