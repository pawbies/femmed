import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="user-medications-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = { ingredients: Array }

  connect() {
    const ingredients = this.ingredientsValue
    const hoursElapsed = Math.floor(Math.random() * 30) // gotta calculate that sometime

    const minTherapeuticDose = Math.floor(Math.random() * 60) + 25  // 25–85
    const minToxicDose = minTherapeuticDose + Math.floor(Math.random() * 60) + 20  // always at least 20 above therapeutic
    const yMax = Math.max(...ingredients.map(i => i.dose), minToxicDose + 20)

    const data = ingredients.flatMap(ingredient => Array.from(
      {length: 48}, (_, t) => ({
        time: t,
        ingredient: ingredient.name,
        concentration: ingredient.dose * Math.pow(0.5, t / ingredient.halfLife)
      })
    ))

    const dots = ingredients.map(ingredient => ({
      time: hoursElapsed,
      ingredient: ingredient.name,
      concentration: ingredient.dose * Math.pow(0.5, hoursElapsed / ingredient.halfLife)
    }))

    const chart = Plot.plot({
      width: this.chartTarget.clientWidth,
      height: this.chartTarget.clientWidth * 0.6,
      style: { fontSize: "10px" },
      y: { domain: [0, yMax] },
      color: { legend: true },
      marks: [
        Plot.rect([{}], {x1: 0, x2: 48, y1: minToxicDose, y2: yMax, fill: "red", fillOpacity: 0.15}),
        Plot.rect([{}], {x1: 0, x2: 48, y1: minTherapeuticDose, y2: minToxicDose, fill: "green", fillOpacity: 0.15}),
        Plot.line(data, { x: "time", y: "concentration", stroke: "ingredient" }),
        Plot.dot(dots, {x: "time", y: "concentration", stroke: "ingredient", r: 5, fill: "white"})
      ],
      x: { label: "Hours after dose" },
      y: { label: "Concentraction (idk must console my bf)" },
    })

    this.chartTarget.append(chart)
  }
}
