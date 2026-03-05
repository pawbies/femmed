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

    // Curated palette — one distinct hue per ingredient slot
    const PALETTE = ["#4f8ef7", "#f5a623", "#34c98a", "#e05c6e", "#a78bfa"]

    const concentrationAt = (ingredient, t) =>
      ingredient.doses.reduce((sum, dose) => {
        const elapsedHours = (now + t * 3600 - dose.takenAt) / 3600
        if (elapsedHours < 0) return sum
        const ke = Math.log(2) / ingredient.halfLife
        const ka = ingredient.absorptionRate
        const vd = ingredient.volumeOfDistribution
        if (Math.abs(ka - ke) < 0.0001) return sum
        const concentration =
          (dose.amount / vd) *
          (ka / (ka - ke)) *
          (Math.exp(-ke * elapsedHours) - Math.exp(-ka * elapsedHours))
        return sum + Math.max(0, concentration)
      }, 0)

    const hasPastDoses = ingredients.some(i =>
      i.doses.some(d => d.takenAt < now)
    )
    const xStart = hasPastDoses ? -24 : 0
    const xEnd = 48

    const data = ingredients.flatMap((ingredient, idx) =>
      Array.from({ length: xEnd - xStart + 1 }, (_, i) => {
        const t = xStart + i
        return {
          time: t,
          ingredient: ingredient.name,
          concentration: concentrationAt(ingredient, t),
          color: PALETTE[idx % PALETTE.length],
        }
      })
    )

    const dots = ingredients.map((ingredient, idx) => ({
      time: 0,
      ingredient: ingredient.name,
      concentration: concentrationAt(ingredient, 0),
      color: PALETTE[idx % PALETTE.length],
    }))

    const localMaxima = ingredients.flatMap((ingredient, idx) => {
      const points = data.filter(d => d.ingredient === ingredient.name)
      return points
        .filter((d, i) => {
          if (i === 0 || i === points.length - 1) return false
          return (
            d.concentration > points[i - 1].concentration &&
            d.concentration > points[i + 1].concentration
          )
        })
        .map(d => ({ ...d, color: PALETTE[idx % PALETTE.length] }))
    })

    let yMax = Math.max(...data.map(d => d.concentration))
    yMax = yMax === 0 ? 1 : yMax * 1.25

    const W = this.chartTarget.clientWidth
    const H = Math.round(W * 0.58)

    // Build a color map for per-ingredient styling
    const colorMap = Object.fromEntries(
      ingredients.map((ing, idx) => [ing.name, PALETTE[idx % PALETTE.length]])
    )

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
        domain: [0, yMax],
        label: "Concentration (mg/L)",
        labelArrow: "up",
        labelOffset: 56,
        tickSize: 0,
        grid: true,
        tickFormat: v => {
          if (v === 0) return "0"
          if (v < 0.001) return v.toExponential(1)
          // Use only as many decimal places as needed to show 2 significant figures
          const magnitude = Math.floor(Math.log10(Math.abs(v)))
          const decimals = Math.max(0, 1 - magnitude)
          return v.toFixed(decimals)
        }
      },

      x: {
        domain: [xStart, xEnd],
        label: "Hours from now →",
        labelAnchor: "right",
        labelOffset: 36,
        tickSize: 0,
        grid: true,
        tickFormat: t =>
          t === 0 ? "now" : `${t > 0 ? "+" : ""}${t}h`,
      },

      color: {
        legend: true,
        domain: ingredients.map(i => i.name),
        range: ingredients.map((_, idx) => PALETTE[idx % PALETTE.length]),
      },

      marks: [
        // Subtle horizontal zero-line
        Plot.ruleY([0], { stroke: "#d1d5db", strokeWidth: 1 }),

        // "Now" vertical guide
        Plot.ruleX([0], {
          stroke: "#94a3b8",
          strokeWidth: 1.5,
          strokeDasharray: "5,3",
        }),

        // Area fill for each ingredient (soft, translucent)
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

        // Main concentration lines
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
          strokeOpacity: 0.5,
        }),

        // Peak crosshair — horizontal
        Plot.ruleY(localMaxima, {
          y: "concentration",
          x1: xStart,
          x2: d => d.time,
          stroke: d => d.color,
          strokeWidth: 1,
          strokeDasharray: "3,3",
          strokeOpacity: 0.5,
        }),

        // "Now" dots — hollow with white fill
        Plot.dot(dots, {
          x: "time",
          y: "concentration",
          fill: "white",
          stroke: d => colorMap[d.ingredient],
          strokeWidth: 2.5,
          r: 5,
        }),

        // "Now" concentration label
        Plot.text(dots, {
          x: "time",
          y: "concentration",
          text: d =>
            d.concentration < 0.001
              ? `~${d.concentration.toExponential(2)} mg/L`
              : `~${d.concentration.toFixed(3)} mg/L`,
          dx: 38,
          dy: -10,
          fontSize: 10.5,
          fontWeight: "600",
          fill: d => colorMap[d.ingredient],
          textAnchor: "start",
        }),

        // Peak label (shown only if meaningfully above the "now" dot)
        Plot.text(
          localMaxima.filter(
            m =>
              m.time !== 0 &&
              dots.find(d => d.ingredient === m.ingredient)?.concentration <
                m.concentration * 0.85
          ),
          {
            x: "time",
            y: "concentration",
            text: d =>
              d.concentration < 0.001
                ? `${d.concentration.toExponential(2)}`
                : `${d.concentration.toFixed(3)} mg/L`,
            dx: 6,
            dy: -10,
            fontSize: 10,
            fontWeight: "500",
            fill: d => d.color,
            textAnchor: "start",
          }
        ),
      ],
    })

    // Post-process: style the auto-generated grid lines subtly
    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line").forEach(el => {
      el.style.stroke = "#e2e8f0"
      el.style.strokeWidth = "1"
    })

    this.chartTarget.append(chart)
  }
}
