import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

const formatConc = c =>
  c < 0.001 ? c.toExponential(2) : c < 0.1 ? c.toFixed(3) : c < 1 ? c.toFixed(2) : c.toFixed(1)

const peakLabel = d => {
  const total = Math.round(d.time * 60)
  const h = Math.floor(total / 60), m = total % 60
  return `${h > 0 ? `${h}h ${m}m` : `${m}m`} · ${formatConc(d.concentration)} mg/L`
}

// Connects to data-controller="medication-preview"
export default class extends Controller {
  static targets = ["chart", "form"]
  static values = { plot: Object }

  connect() {
    this.chartTarget.innerHTML = ""
    const { series, local_maxima: localMaxima, y_max: yMax, ingredients: ingredientsMeta } = this.plotValue
    const empty = ingredientsMeta.length === 0
    const xStart = 0
    const xEnd = 24

    const ingredients = ingredientsMeta.map(i => i.name)
    const colorMap = Object.fromEntries(ingredientsMeta.map(i => [i.name, i.color]))

    const W = this.chartTarget.clientWidth
    const H = Math.round(W * 0.58)

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 64, marginRight: 24, marginTop: 28, marginBottom: 44,
      style: { fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif", fontSize: "11px", background: "transparent", overflow: "visible" },
      y: {
        domain: [0, empty ? 1 : yMax * 1.25], label: "Concentration (mg/L)", labelArrow: "up", labelOffset: 56, tickSize: 0, grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          const decimals = Math.max(0, 1 - Math.floor(Math.log10(Math.abs(v))))
          return v < 0.001 ? v.toExponential(1) : v.toFixed(decimals)
        },
      },
      x: {
        domain: [xStart, xEnd], label: "Hours from intake →", labelAnchor: "right", labelOffset: 36, tickSize: 0, grid: true,
        tickFormat: t => t === 0 ? "Intake" : `+${t}h`,
      },
      color: {
        legend: !empty,
        domain: ingredients,
        range: ingredients.map(n => colorMap[n]),
      },
      marks: empty
        ? [Plot.text([{ x: xEnd / 2, y: 0.5 }], { x: "x", y: "y", text: () => "No PK data available for this medication version", fontSize: 12, fill: "#94a3b8", textAnchor: "middle" })]
        : [
            Plot.ruleY([0], { stroke: "#d1d5db", strokeWidth: 1 }),
            Plot.ruleX([0], { stroke: "#94a3b8", strokeWidth: 1.5, strokeDasharray: "5,3" }),
            ...ingredients.map(name =>
              Plot.areaY(series.filter(d => d.ingredient === name), { x: "time", y: "concentration", fill: colorMap[name], fillOpacity: 0.08, curve: "catmull-rom" })
            ),
            ...ingredients.map(name =>
              Plot.line(series.filter(d => d.ingredient === name), { x: "time", y: "concentration", stroke: colorMap[name], strokeWidth: 2.5, curve: "catmull-rom" })
            ),
            Plot.ruleX(localMaxima, { x: "time", y1: 0, y2: "concentration", stroke: d => d.color, strokeWidth: 1, strokeDasharray: "3,3", strokeOpacity: 0.45 }),
            Plot.ruleY(localMaxima, { y: "concentration", x1: xStart, x2: d => d.time, stroke: d => d.color, strokeWidth: 1, strokeDasharray: "3,3", strokeOpacity: 0.45 }),
            Plot.text(localMaxima, { x: "time", y: "concentration", text: peakLabel, fontSize: 10, fontWeight: "600", dx: 8, dy: -10, fill: d => d.color, textAnchor: "start" })
          ],
    })

    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => { el.style.stroke = "#e2e8f0"; el.style.strokeWidth = "1" })

    this.chartTarget.append(chart)
  }

  update() {
    this.formTarget.requestSubmit()
  }
}
