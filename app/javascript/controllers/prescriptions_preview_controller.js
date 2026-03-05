import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="prescriptions-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = { ingredients: Array }

  connect() {
    this.chartTarget.innerHTML = ""
    const ingredients = this.ingredientsValue
    const now = Math.floor(Date.now() / 1000)

    /*
    const concentrationAt = (ingredient, t) =>
      ingredient.doses.reduce((sum, dose) => {
        const elapsedHours = (now + t * 3600 - dose.takenAt) / 3600
        if (elapsedHours < 0) return sum
        return sum + dose.amount * Math.pow(0.5, elapsedHours / ingredient.halfLife)
      }, 0)
    */

    const concentrationAt = (ingredient, t) =>
      ingredient.doses.reduce((sum, dose) => {
        const elapsedHours = (now + t * 3600 - dose.takenAt) / 3600
        if (elapsedHours < 0) return sum

        const ke = Math.log(2) / ingredient.halfLife      // elimination rate
        const ka = ingredient.absorptionRate               // absorption rate
        const vd = ingredient.volumeOfDistribution


        if (Math.abs(ka - ke) < 0.0001) return sum // degenerate case, skip
        // Two-compartment oral absorption model
        const concentration = (dose.amount / vd) *
          (ka / (ka - ke)) *
          (Math.exp(-ke * elapsedHours) - Math.exp(-ka * elapsedHours))

        return sum + Math.max(0, concentration)
      }, 0)

    // Only go back in time if there are actual past doses to show
    const hasPastDoses = ingredients.some(i => i.doses.some(d => d.takenAt < now))
    const xStart = hasPastDoses ? -24 : 0
    const xEnd = 48

    const data = ingredients.flatMap(ingredient =>
      Array.from({ length: (xEnd - xStart) + 1 }, (_, i) => {
        const t = xStart + i
        return { time: t, ingredient: ingredient.name, concentration: concentrationAt(ingredient, t) }
      })
    )

    const dots = ingredients.map(ingredient => ({
      time: 0,
      ingredient: ingredient.name,
      concentration: concentrationAt(ingredient, 0),
    }))

    const localMaxima = ingredients.flatMap(ingredient => {
      const points = data.filter(d => d.ingredient === ingredient.name)
      return points.filter((d, i) => {
        if (i === 0 || i === points.length - 1) return false
        return d.concentration > points[i - 1].concentration &&
              d.concentration > points[i + 1].concentration
      })
    })

    const minTherapeuticDose = 40
    const minToxicDose = 120
    const allConcentrations = data.map(d => d.concentration)
    // Floor yMax so the axis doesn't render as "00000" when empty
    let yMax = Math.max(...allConcentrations)
    if (yMax == 0) {
      yMax = 1
    } else {
      yMax *= 1.2
    }

    const chart = Plot.plot({
      width: this.chartTarget.clientWidth,
      height: this.chartTarget.clientWidth * 0.6,
      style: { fontSize: "10px" },
      y: { domain: [0, yMax], label: "Concentration (mg/L)" },
      x: {
        domain: [xStart, xEnd],
        label: "Hours from now",
        tickFormat: t => t === 0 ? "now" : `${t > 0 ? "+" : ""}${t}h`
      },
      color: { legend: true },
      marks: [
        Plot.ruleX([0], { stroke: "#aaa", strokeDasharray: "4,2" }),
        Plot.line(data, { x: "time", y: "concentration", stroke: "ingredient" }),
        Plot.dot(dots,  { x: "time", y: "concentration", stroke: "ingredient", r: 5, fill: "white" }),
        Plot.text(dots, { x: "time", y: "concentration", text: d => `~${d.concentration.toFixed(3)}mg/L`, dx: 35, dy: -10, fontSize: 10, fill: "currentColor" }),
        Plot.ruleX(localMaxima, { x: "time", y1: 0, y2: "concentration", stroke: "red", strokeDasharray: "3,2", strokeOpacity: 0.4 }),
        Plot.ruleY(localMaxima, { y: "concentration", x1: xStart, x2: d => d.time, stroke: "red", strokeDasharray: "3,2", strokeOpacity: 0.4 }),
      ]
    })

    this.chartTarget.append(chart)
  }
}
