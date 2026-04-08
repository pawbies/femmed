import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

const formatConc = (c, prefix = "") =>
  c < 0.001 ? `${prefix}${c.toExponential(2)}` : `${prefix}${c.toFixed(3)} mg/L`

// Connects to data-controller="prescriptions-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = {
    plot: Object,
    past: Number,
    future: Number,
    xlabel: String,
    ylabel: String,
    nowlabel: String
  }

  connect() {
    this.chartTarget.innerHTML = ""
    const { series, dots, local_maxima: localMaxima, y_max: yMax } = this.plotValue
    const xStart = this.pastValue * -1
    const xEnd = this.futureValue

    const xLabel = this.xlabelValue
    const yLabel = this.ylabelValue
    const nowLabel = this.nowlabelValue

    const ingredients = [...new Set(series.map(d => d.ingredient))]
    const colorMap = Object.fromEntries(series.map(d => [d.ingredient, d.color]))

    const W = this.chartTarget.clientWidth
    const H = Math.round(W * 0.58)

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 64, marginRight: 24, marginTop: 28, marginBottom: 44,
      style: { fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif", fontSize: "11px", background: "transparent", overflow: "visible" },
      y: {
        domain: [0, yMax * 1.25], label: yLabel, labelArrow: "up", labelOffset: 56, tickSize: 0, grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          const decimals = Math.max(0, 1 - Math.floor(Math.log10(Math.abs(v))))
          return v < 0.001 ? v.toExponential(1) : v.toFixed(decimals)
        },
      },
      x: {
        domain: [xStart, xEnd], label: xLabel, labelAnchor: "right", labelOffset: 36, tickSize: 0, grid: true,
        tickFormat: t => t === 0 ? nowLabel : `${t > 0 ? "+" : ""}${t}h`,
      },
      color: { legend: true, domain: ingredients, range: ingredients.map(n => colorMap[n]) },
      marks: [
        Plot.ruleY([0], { stroke: "#d1d5db", strokeWidth: 1 }),
        Plot.ruleX([0], { stroke: "#94a3b8", strokeWidth: 1.5, strokeDasharray: "5,3" }),
        ...ingredients.map(name =>
          Plot.areaY(series.filter(d => d.ingredient === name), { x: "time", y: "concentration", fill: colorMap[name], fillOpacity: 0.08, curve: "catmull-rom" })
        ),
        ...ingredients.map(name =>
          Plot.line(series.filter(d => d.ingredient === name), { x: "time", y: "concentration", stroke: colorMap[name], strokeWidth: 2.5, curve: "catmull-rom" })
        ),
        Plot.ruleX(localMaxima, { x: "time", y1: 0, y2: "concentration", stroke: d => d.color, strokeWidth: 1, strokeDasharray: "3,3", strokeOpacity: 0.5 }),
        Plot.ruleY(localMaxima, { y: "concentration", x1: xStart, x2: d => d.time, stroke: d => d.color, strokeWidth: 1, strokeDasharray: "3,3", strokeOpacity: 0.5 }),
        Plot.dot(dots, { x: "time", y: "concentration", fill: "white", stroke: d => colorMap[d.ingredient], strokeWidth: 2.5, r: 5 }),
        Plot.text(dots, { x: "time", y: "concentration", text: d => formatConc(d.concentration, "~"), dx: 38, dy: -10, fontSize: 10.5, fontWeight: "600", fill: d => colorMap[d.ingredient], textAnchor: "start" })
      ]
    })

    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => { el.style.stroke = "#e2e8f0"; el.style.strokeWidth = "1" })

    this.chartTarget.append(chart)
  }
}
