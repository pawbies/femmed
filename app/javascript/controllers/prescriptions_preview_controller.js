import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

const PALETTE = ["#4f8ef7", "#f5a623", "#34c98a", "#e05c6e", "#a78bfa"]
const color = (_, idx) => PALETTE[idx % PALETTE.length]

const ke = ing => Math.log(2) / ing.halfLife

const formatConc = (c, prefix = "") =>
  c < 0.001 ? `${prefix}${c.toExponential(2)}` : `${prefix}${c.toFixed(3)} mg/L`

const peakLabel = d => {
  return formatConc(d.concentration)
}

// Connects to data-controller="prescriptions-preview"
export default class extends Controller {
  static targets = ["chart"]
  static values = { ingredients: Array, releaseProfile: Object }

  connect() {
    this.chartTarget.innerHTML = ""
    const ingredients = this.ingredientsValue
    const releaseProfile = this.releaseProfileValue
    const now = Math.floor(Date.now() / 1000)
    const xStart = ingredients.some(i => i.doses.some(d => d.takenAt < now)) ? -24 : 0
    const xEnd = 48

    const concentrationAt = (ing, t) =>
      ing.doses.reduce((sum, dose) => {
        const elapsed = (now + t * 3600 - dose.takenAt) / 3600
        if (elapsed < 0) return sum
        const _ke = ke(ing), ka = ing.absorptionRate, vd = ing.volumeOfDistribution
        if (Math.abs(ka - _ke) < 0.0001) return sum

        const pulse = (offset) => {
          const e = elapsed - offset
          if (e < 0) return 0
          return Math.max(0, (dose.amount / vd) * (ka / (ka - _ke)) * (Math.exp(-_ke * e) - Math.exp(-ka * e)))
        }

        if (releaseProfile.name === "Bimodal") return sum + pulse(0) + pulse(releaseProfile.delay)

        if (releaseProfile.name === "Extended") {
          const T = releaseProfile.release_duration
          const base = (dose.amount / T) / (vd * _ke)
          const c = elapsed <= T
            ? base * (1 - Math.exp(-_ke * elapsed))
            : base * (1 - Math.exp(-_ke * T)) * Math.exp(-_ke * (elapsed - T))
          return sum + Math.max(0, c)
        }

        return sum + pulse(0)
      }, 0)

    const data = ingredients.flatMap((ing, idx) =>
      Array.from({ length: xEnd - xStart + 1 }, (_, i) => ({
        time: xStart + i, ingredient: ing.name, concentration: concentrationAt(ing, xStart + i), color: color(ing, idx),
      }))
    )

    const dots = ingredients.map((ing, idx) => ({
      time: 0, ingredient: ing.name, concentration: concentrationAt(ing, 0), color: color(ing, idx),
    }))

    const localMaxima = ingredients.flatMap((ing, idx) => {
      const points = data.filter(d => d.ingredient === ing.name)
      return points
        .filter((d, i) => i > 0 && i < points.length - 1 && d.concentration > points[i - 1].concentration && d.concentration > points[i + 1].concentration)
        .map(d => ({ ...d, color: color(ing, idx) }))
    })

    const yMax = Math.max(...data.map(d => d.concentration)) || 1
    const W = this.chartTarget.clientWidth
    const H = Math.round(W * 0.58)
    const colorMap = Object.fromEntries(ingredients.map((ing, idx) => [ing.name, color(ing, idx)]))

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 64, marginRight: 24, marginTop: 28, marginBottom: 44,
      style: { fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif", fontSize: "11px", background: "transparent", overflow: "visible" },
      y: {
        domain: [0, yMax * 1.25], label: "Concentration (mg/L)", labelArrow: "up", labelOffset: 56, tickSize: 0, grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          const decimals = Math.max(0, 1 - Math.floor(Math.log10(Math.abs(v))))
          return v < 0.001 ? v.toExponential(1) : v.toFixed(decimals)
        },
      },
      x: {
        domain: [xStart, xEnd], label: "Hours from now →", labelAnchor: "right", labelOffset: 36, tickSize: 0, grid: true,
        tickFormat: t => t === 0 ? "now" : `${t > 0 ? "+" : ""}${t}h`,
      },
      color: { legend: true, domain: ingredients.map(i => i.name), range: ingredients.map(color) },
      marks: [
        Plot.ruleY([0], { stroke: "#d1d5db", strokeWidth: 1 }),
        Plot.ruleX([0], { stroke: "#94a3b8", strokeWidth: 1.5, strokeDasharray: "5,3" }),
        ...ingredients.map((ing, idx) =>
          Plot.areaY(data.filter(d => d.ingredient === ing.name), { x: "time", y: "concentration", fill: color(ing, idx), fillOpacity: 0.08, curve: "catmull-rom" })
        ),
        ...ingredients.map((ing, idx) =>
          Plot.line(data.filter(d => d.ingredient === ing.name), { x: "time", y: "concentration", stroke: color(ing, idx), strokeWidth: 2.5, curve: "catmull-rom" })
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
