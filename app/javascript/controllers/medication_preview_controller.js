import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="medication-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = { ingredients: Array }

  connect() {
    this.chartTarget.innerHTML = ""
    const ingredients = this.ingredientsValue
    const emptyIngredients = this.ingredientsValue.length === 0
    console.log(this.ingredientsValue)

    const concentrationAt = (ingredient, t) => {
      const elapsedHours = t
      if (elapsedHours < 0) return 0

      const ke = Math.log(2) / ingredient.halfLife      // elimination rate
      const ka = ingredient.absorptionRate               // absorption rate
      const vd = ingredient.volumeOfDistribution


      if (Math.abs(ka - ke) < 0.0001) return 0 // degenerate case, skip
      // Two-compartment oral absorption model
      const concentration = (ingredient.amount / vd) *
        (ka / (ka - ke)) *
        (Math.exp(-ke * elapsedHours) - Math.exp(-ka * elapsedHours))

      return Math.max(0, concentration)
    }

    const xStart = 0
    const xEnd = 48

    const data = ingredients.flatMap(ingredient =>
      Array.from({ length: (xEnd - xStart) + 1 }, (_, i) => {
        const t = xStart + i
        return { time: t, ingredient: ingredient.name, concentration: concentrationAt(ingredient, t) }
      })
    )


    const localMaxima = ingredients.flatMap(ingredient => {
      const ke = Math.log(2) / ingredient.halfLife
      const ka = ingredient.absorptionRate
      if (Math.abs(ka - ke) < 0.0001) return []
      const tMax = Math.log(ka / ke) / (ka - ke)
      return [{
        time: tMax,
        ingredient: ingredient.name,
        concentration: concentrationAt(ingredient, tMax)
      }]
    })

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
      y: { domain: [0, emptyIngredients ? 1 : yMax], label: "Concentration (mg/L)" },
      x: {
        domain: [xStart, xEnd],
        label: "Hours from now",
        tickFormat: t => t === 0 ? "Intake" : `${t > 0 ? "+" : ""}${t}h`
      },
      color: { legend: !emptyIngredients },
      marks: emptyIngredients ? [
        Plot.text([{ x: 24, y: 0.5 }], {
          x: "x", y: "y",
          text: () => "No PK data available for this medication version",
          fontSize: 12,
          fill: "red",
          textAnchor: "middle"
        })
      ] : [
        Plot.ruleX([0], { stroke: "#aaa", strokeDasharray: "4,2" }),
        Plot.line(data, { x: "time", y: "concentration", stroke: "ingredient" }),
        Plot.ruleX(localMaxima, { x: "time", y1: 0, y2: "concentration", stroke: "red", strokeDasharray: "3,2", strokeOpacity: 0.4 }),
        Plot.ruleY(localMaxima, { y: "concentration", x1: xStart, x2: d => d.time, stroke: "red", strokeDasharray: "3,2", strokeOpacity: 0.4 }),
        Plot.text(localMaxima, {
          x: "time", y: "concentration",
          text: d => {
            const formatConc = c => c < 0.1 ? c.toFixed(3) : c < 1 ? c.toFixed(2) : c.toFixed(1)
            const totalMinutes = Math.round(d.time * 60)
            const hours = Math.floor(totalMinutes / 60)
            const minutes = totalMinutes % 60
            const timePart = hours > 0
              ? `${hours}h ${minutes}m`
              : `${minutes}m`
            return `${timePart} after intake ~ ${formatConc(d.concentration)} mg/L`
          },
          fontSize: 10,
          dx: 100, dy: -12,
          fill: "red"
        }),
      ]
    })

    this.chartTarget.append(chart)
  }
}
