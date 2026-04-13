import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

// Zones drawn back-to-front (each overwrites the one before in its area)
// Low spans full width — any sys < 90 is low regardless of diastolic
const ZONES = [
  { x1: 40, x2: 100, y1: 70,  y2: 190, fill: "#fca5a5", lx: 72,  ly: 168, label: "High blood pressure",     lc: "#991b1b" },
  { x1: 40, x2: 90,  y1: 70,  y2: 140, fill: "#fde68a", lx: 65,  ly: 128, label: "Pre-high blood pressure",  lc: "#92400e" },
  { x1: 40, x2: 80,  y1: 70,  y2: 120, fill: "#86efac", lx: 60,  ly: 105, label: "Ideal blood pressure",     lc: "#166534" },
  { x1: 40, x2: 60,  y1: 70,  y2: 90,  fill: "#c4b5fd", lx: 50,  ly: 80,  label: "Low",                     lc: "#4c1d95" },
]


// Badge classification: sys < 90 is always Low (even if dot falls in yellow visually)
function classify(sys, dia) {
  if (sys > 140 || dia > 90)              return ZONES[0] // High
  if (sys < 90)                           return ZONES[3] // Low systolic → Low
  if (dia < 60)                           return ZONES[3] // Low diastolic → Low
  if (sys <= 120 && dia <= 80)            return ZONES[2] // Ideal
  return ZONES[1]                                         // Pre-high
}

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max)
}

// Connects to data-controller="blood-pressure-graph"
export default class extends Controller {
  static targets = ["chart", "badge"]
  static values  = { sys: Number, dia: Number }

  connect() {
    this.render()
  }

  render() {
    this.chartTarget.innerHTML = ""

    const sys = clamp(this.sysValue, 70, 190)
    const dia = clamp(this.diaValue, 40, 100)
    const zone = classify(sys, dia)

    // Update badge if present
    if (this.hasBadgeTarget) {
      this.badgeTarget.textContent = zone.label
      this.badgeTarget.style.color = zone.lc
    }

    const W = this.chartTarget.clientWidth || 420
    const H = Math.round(W * 0.95)

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 56, marginRight: 16, marginTop: 16, marginBottom: 52,
      style: {
        fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif",
        fontSize: "11px",
        background: "transparent",
        overflow: "visible",
      },
      x: {
        domain: [40, 100],
        label: "Diastolic (mmHg) →",
        labelAnchor: "center",
        labelOffset: 40,
        tickSize: 0,
        ticks: [40, 50, 60, 70, 80, 90, 100],
        grid: true,
      },
      y: {
        domain: [70, 190],
        label: "↑ Systolic (mmHg)",
        labelOffset: 48,
        tickSize: 0,
        ticks: [70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190],
        grid: true,
      },
      marks: [
        // Zone rectangles (back to front)
        ...ZONES.map(z =>
          Plot.rect([z], { x1: "x1", x2: "x2", y1: "y1", y2: "y2", fill: z.fill })
        ),

        // Zone labels
        ...ZONES.map(z =>
          Plot.text([z], {
            x: "lx", y: "ly",
            text: "label",
            fill: z.lc,
            fontSize: 11,
            fontWeight: "700",
            textAnchor: "middle",
            lineWidth: 8,
          })
        ),

        // Crosshair lines for the reading
        Plot.ruleX([{ x: dia }], { x: "x", stroke: "#1e293b", strokeWidth: 1.5, strokeDasharray: "4,3", strokeOpacity: 0.6 }),
        Plot.ruleY([{ y: sys }], { y: "y", stroke: "#1e293b", strokeWidth: 1.5, strokeDasharray: "4,3", strokeOpacity: 0.6 }),

        // Reading dot
        Plot.dot([{ x: dia, y: sys }], {
          x: "x", y: "y",
          r: 7,
          fill: "white",
          stroke: "#1e293b",
          strokeWidth: 2.5,
        }),
      ],
    })

    // Style gridlines subtly
    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => { el.style.stroke = "rgba(0,0,0,0.12)"; el.style.strokeWidth = "1" })

    this.chartTarget.append(chart)
  }
}
