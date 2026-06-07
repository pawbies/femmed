import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

const formatConc = (c, prefix = "") =>
  c < 0.001 ? `${prefix}${c.toExponential(2)}` : `${prefix}${c.toFixed(3)} mg/L`

// Format an x-axis offset (in hours from now) as a compact label.
const formatOffset = (t, nowLabel) => {
  if (t === 0) return nowLabel
  const sign = t > 0 ? "+" : "-"
  const abs = Math.abs(t)
  if (abs % 24 === 0) return `${sign}${abs / 24}d`
  if (abs >= 24) return `${sign}${Math.floor(abs / 24)}d ${abs % 24}h`
  return `${sign}${abs}h`
}

// Connects to data-controller="prescription-graph"
// Larger sibling of prescriptions-preview: same dose-history data, but rendered
// taller and with a custom past/future time range driven by the form.
export default class extends Controller {
  static targets = ["chart", "form"]
  static values = {
    plot: Object,
    past: Number,
    future: Number,
    xlabel: String,
    ylabel: String,
    nowlabel: String
  }

  connect() {
    this.render()
    this.resizeHandler = () => this.render()
    window.addEventListener("resize", this.resizeHandler)
  }

  disconnect() {
    window.removeEventListener("resize", this.resizeHandler)
  }

  render() {
    this.chartTarget.innerHTML = ""
    const { series, dots, local_maxima: localMaxima, y_max: yMax } = this.plotValue
    const xStart = this.pastValue * -1
    const xEnd = this.futureValue

    const xLabel = this.xlabelValue
    const yLabel = this.ylabelValue
    const nowLabel = this.nowlabelValue

    const ingredients = [...new Set(series.map(d => d.ingredient))]
    const colorMap = Object.fromEntries(series.map(d => [d.ingredient, d.color]))

    const W = this.chartTarget.clientWidth || 640
    // Taller than the preview (which uses 0.58) and capped so very wide
    // screens stay readable rather than producing a giant chart.
    const H = Math.min(Math.round(W * 0.5), 560)

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 72, marginRight: 28, marginTop: 32, marginBottom: 52,
      style: { fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif", fontSize: "12px", background: "transparent", overflow: "visible" },
      y: {
        domain: [0, (yMax || 1) * 1.25], label: yLabel, labelArrow: "up", labelOffset: 60, tickSize: 0, grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          const decimals = Math.max(0, 1 - Math.floor(Math.log10(Math.abs(v))))
          return v < 0.001 ? v.toExponential(1) : v.toFixed(decimals)
        },
      },
      x: {
        domain: [xStart, xEnd], label: xLabel, labelAnchor: "right", labelOffset: 40, tickSize: 0, grid: true,
        tickFormat: t => formatOffset(t, nowLabel),
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
        Plot.text(dots, { x: "time", y: "concentration", text: d => formatConc(d.concentration, "~"), dx: 38, dy: -10, fontSize: 11, fontWeight: "600", fill: d => colorMap[d.ingredient], textAnchor: "start" })
      ]
    })

    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => { el.style.stroke = "#e2e8f0"; el.style.strokeWidth = "1" })

    this.chartTarget.append(chart)
  }

  update() {
    this.formTarget.requestSubmit()
  }
}
