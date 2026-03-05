import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Connects to data-controller="medication-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = { ingredients: Array }

  connect() {
    const ingredients = this.ingredientsValue
    const emptyIngredients = ingredients.length === 0

    // Curated palette — one distinct hue per ingredient slot
    const PALETTE = ["#4f8ef7", "#f5a623", "#34c98a", "#e05c6e", "#a78bfa"]

    const colorMap = Object.fromEntries(
      ingredients.map((ing, idx) => [ing.name, PALETTE[idx % PALETTE.length]])
    )

    const concentrationAt = (ingredient, t) => {
      if (t < 0) return 0
      const ke = Math.log(2) / ingredient.halfLife
      const ka = ingredient.absorptionRate
      const vd = ingredient.volumeOfDistribution
      if (Math.abs(ka - ke) < 0.0001) return 0
      const concentration =
        (ingredient.amount / vd) *
        (ka / (ka - ke)) *
        (Math.exp(-ke * t) - Math.exp(-ka * t))
      return Math.max(0, concentration)
    }

    const xStart = 0
    const xEnd = 48

    const data = ingredients.flatMap((ingredient, idx) =>
      Array.from({ length: xEnd - xStart + 1 }, (_, i) => ({
        time: xStart + i,
        ingredient: ingredient.name,
        concentration: concentrationAt(ingredient, xStart + i),
        color: PALETTE[idx % PALETTE.length],
      }))
    )

    const localMaxima = ingredients.flatMap((ingredient, idx) => {
      const ke = Math.log(2) / ingredient.halfLife
      const ka = ingredient.absorptionRate
      if (Math.abs(ka - ke) < 0.0001) return []
      const tMax = Math.log(ka / ke) / (ka - ke)
      return [{
        time: tMax,
        ingredient: ingredient.name,
        concentration: concentrationAt(ingredient, tMax),
        color: PALETTE[idx % PALETTE.length],
      }]
    })

    let yMax = Math.max(...data.map(d => d.concentration))
    yMax = yMax === 0 ? 1 : yMax * 1.25

    const W = this.chartTarget.clientWidth
    const H = Math.round(W * 0.58)

    const formatConc = c =>
      c < 0.001
        ? c.toExponential(2)
        : c < 0.1
        ? c.toFixed(3)
        : c < 1
        ? c.toFixed(2)
        : c.toFixed(1)

    const chart = Plot.plot({
      width: W,
      height: H,
      marginLeft: 64,
      marginRight: 24,
      marginTop: 28,
      marginBottom: 44,

      style: {
        fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif",
        fontSize: "11px",
        background: "transparent",
        overflow: "visible",
      },

      y: {
        domain: [0, emptyIngredients ? 1 : yMax],
        label: "Concentration (mg/L)",
        labelArrow: "up",
        labelOffset: 56,
        tickSize: 0,
        grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          if (v < 0.001) return v.toExponential(1)
          const magnitude = Math.floor(Math.log10(Math.abs(v)))
          const decimals = Math.max(0, 1 - magnitude)
          return v.toFixed(decimals)
        },
      },

      x: {
        domain: [xStart, xEnd],
        label: "Hours from intake →",
        labelAnchor: "right",
        labelOffset: 36,
        tickSize: 0,
        grid: true,
        tickFormat: t => (t === 0 ? "Intake" : `+${t}h`),
      },

      color: {
        legend: !emptyIngredients,
        domain: ingredients.map(i => i.name),
        range: ingredients.map((_, idx) => PALETTE[idx % PALETTE.length]),
      },

      marks: emptyIngredients
        ? [
            Plot.text([{ x: 24, y: 0.5 }], {
              x: "x",
              y: "y",
              text: () => "No PK data available for this medication version",
              fontSize: 12,
              fill: "#94a3b8",
              textAnchor: "middle",
            }),
          ]
        : [
            // Zero baseline
            Plot.ruleY([0], { stroke: "#d1d5db", strokeWidth: 1 }),

            // Intake marker
            Plot.ruleX([0], {
              stroke: "#94a3b8",
              strokeWidth: 1.5,
              strokeDasharray: "5,3",
            }),

            // Area fills
            ...ingredients.map((ing, idx) =>
              Plot.areaY(
                data.filter(d => d.ingredient === ing.name),
                {
                  x: "time",
                  y: "concentration",
                  fill: PALETTE[idx % PALETTE.length],
                  fillOpacity: 0.08,
                  curve: "catmull-rom",
                }
              )
            ),

            // Concentration lines
            ...ingredients.map((ing, idx) =>
              Plot.line(
                data.filter(d => d.ingredient === ing.name),
                {
                  x: "time",
                  y: "concentration",
                  stroke: PALETTE[idx % PALETTE.length],
                  strokeWidth: 2.5,
                  curve: "catmull-rom",
                }
              )
            ),

            // Peak crosshair — vertical
            Plot.ruleX(localMaxima, {
              x: "time",
              y1: 0,
              y2: "concentration",
              stroke: d => d.color,
              strokeWidth: 1,
              strokeDasharray: "3,3",
              strokeOpacity: 0.45,
            }),

            // Peak crosshair — horizontal
            Plot.ruleY(localMaxima, {
              y: "concentration",
              x1: xStart,
              x2: d => d.time,
              stroke: d => d.color,
              strokeWidth: 1,
              strokeDasharray: "3,3",
              strokeOpacity: 0.45,
            }),

            // Peak label
            Plot.text(localMaxima, {
              x: "time",
              y: "concentration",
              text: d => {
                const totalMinutes = Math.round(d.time * 60)
                const hours = Math.floor(totalMinutes / 60)
                const minutes = totalMinutes % 60
                const timePart =
                  hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`
                return `${timePart} · ${formatConc(d.concentration)} mg/L`
              },
              fontSize: 10,
              fontWeight: "600",
              dx: 8,
              dy: -10,
              fill: d => d.color,
              textAnchor: "start",
            }),
          ],
    })

    // Soften auto-generated grid lines
    chart
      .querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => {
        el.style.stroke = "#e2e8f0"
        el.style.strokeWidth = "1"
      })

    this.chartTarget.innerHTML = ""
    this.chartTarget.append(chart)
  }
}
