import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="user-medications-preview"
export default class extends Controller {
  static targets = ["chart"]

  connect() {
    const halfLife = Math.floor(Math.random() * 15)
    const initialDose = Math.floor(Math.random() * 300) + 50
    const doseAt = new Date("2025-02-22T08:00:00")
    const hoursElapsed = Math.floor(Math.random() * 30) // gotta calculate that sometime
    const currentConcentration = initialDose * Math.pow(0.5, hoursElapsed / halfLife)


    const minTherapeuticDose = Math.floor(Math.random() * 60) + 25  // 25–85
    const minToxicDose = minTherapeuticDose + Math.floor(Math.random() * 60) + 20  // always at least 20 above therapeutic
    const yMax = Math.max(initialDose, minToxicDose + 20)  // ensure red zone is always visible

    const data = Array.from({length: 48}, (_, t) => ({
      time: t,
      concentration: initialDose * Math.pow(0.5, t / halfLife)
    }))

    const chart = Plot.plot({
      width: 500,
      height: 300,
      style: { fontSize: "10px" },
      y: { domain: [0, yMax] },
      marks: [
        Plot.rect([{}], {x1: 0, x2: 48, y1: minToxicDose, y2: yMax, fill: "red", fillOpacity: 0.15}),
        Plot.rect([{}], {x1: 0, x2: 48, y1: minTherapeuticDose, y2: minToxicDose, fill: "green", fillOpacity: 0.15}),
        Plot.line(data, { x: "time", y: "concentration" }),
        Plot.dot([{ time: hoursElapsed, concentration: currentConcentration }], {
          x: "time",
          y: "concentration",
          r: 5,
          fill: "steelblue"
        })
      ],
      x: { label: "Hours after dose" },
      y: { label: "Concentraction (mg)" },
    })

    this.chartTarget.append(chart)
  }
}
