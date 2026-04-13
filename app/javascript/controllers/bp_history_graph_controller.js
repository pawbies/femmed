import { Controller } from "@hotwired/stimulus"
import * as Plot from "@observablehq/plot"

const COLORS = {
  sys: "#f43f5e",
  dia: "#fb923c",
  bpm: "#6366f1",
  rx:  "#94a3b8",
}

// Connects to data-controller="bp-history-graph"
export default class extends Controller {
  static targets = ["chart", "toggle"]
  static values  = { sys: Array, dia: Array, bpm: Array, medications: Array, start: String }

  connect() {
    this.hidden = new Set()
    this.render()
  }

  toggleSeries(event) {
    const s = event.currentTarget.dataset.series
    this.hidden.has(s) ? this.hidden.delete(s) : this.hidden.add(s)

    // Sync visual state
    this.toggleTargets.forEach(btn => {
      const active = !this.hidden.has(btn.dataset.series)
      btn.style.opacity = active ? "1" : "0.4"
      const label = btn.querySelector("[data-label]")
      if (label) label.style.textDecoration = active ? "none" : "line-through"
    })

    this.render()
  }

  render() {
    this.chartTarget.innerHTML = ""

    const now = new Date()

    const parse = (arr) =>
      arr
        .map(d => ({ ...d, measured_at: new Date(d.measured_at) }))
        .filter(d => d.value != null)
        .sort((a, b) => a.measured_at - b.measured_at)

    const allDates = [...this.sysValue, ...this.diaValue, ...this.bpmValue]
      .map(d => new Date(d.measured_at))
      .filter(d => !isNaN(d))
    const start = this.startValue
      ? new Date(this.startValue)
      : allDates.length ? new Date(Math.min(...allDates)) : new Date(now - 30 * 864e5)

    const sys = this.hidden.has("sys") ? [] : parse(this.sysValue)
    const dia = this.hidden.has("dia") ? [] : parse(this.diaValue)
    const bpm = this.hidden.has("bpm") ? [] : parse(this.bpmValue)
    const empty = sys.length === 0 && dia.length === 0 && bpm.length === 0

    const rx = this.medicationsValue
      .map(d => ({ ...d, created_at: new Date(d.created_at) }))
      .filter(d => d.created_at >= start)

    // Y domain relative to visible series; fall back to 0–160 when nothing shown
    const visibleValues = [...sys, ...dia, ...bpm].map(d => d.value)
    const yMin = visibleValues.length ? Math.max(0, Math.min(...visibleValues) - 10) : 0
    const yMax = visibleValues.length ? Math.max(...visibleValues) + 15 : 160

    const W = this.chartTarget.clientWidth || 600
    const H = Math.round(W * 0.5)

    const series = [
      ...sys.map(d => ({ ...d, series: "Systolic" })),
      ...dia.map(d => ({ ...d, series: "Diastolic" })),
      ...bpm.map(d => ({ ...d, series: "Heart rate" })),
    ]

    const chart = Plot.plot({
      width: W, height: H,
      marginLeft: 52, marginRight: 24, marginTop: 28, marginBottom: 44,
      style: {
        fontFamily: "'Inter', 'DM Sans', system-ui, sans-serif",
        fontSize: "11px",
        background: "transparent",
        overflow: "visible",
      },
      x: {
        domain: [start, now],
        label: null,
        tickSize: 0,
        grid: true,
        tickFormat: d => d.toLocaleDateString(undefined, { month: "short", day: "numeric" }),
      },
      y: {
        domain: [yMin, yMax],
        label: "mmHg / bpm",
        labelArrow: "up",
        labelOffset: 44,
        tickSize: 0,
        grid: true,
      },
      marks: empty
        ? [
            Plot.text([{ x: new Date((start.getTime() + now.getTime()) / 2), y: (yMin + yMax) / 2 }], {
              x: "x", y: "y",
              text: () => "No data selected",
              fontSize: 12, fill: "#94a3b8", textAnchor: "middle",
            }),
          ]
        : [
            Plot.ruleY([yMin], { stroke: "#d1d5db", strokeWidth: 1 }),

            // Prescription vertical lines
            ...rx.map(med =>
              Plot.ruleX([med], {
                x: "created_at",
                stroke: COLORS.rx,
                strokeWidth: 1.5,
                strokeDasharray: "4,3",
                strokeOpacity: 0.7,
              })
            ),
            ...rx.map(med =>
              Plot.text([med], {
                x: "created_at",
                y: yMax,
                text: d => d.name,
                fontSize: 9,
                fontWeight: "600",
                fill: COLORS.rx,
                textAnchor: "start",
                rotate: 90,
                dx: 6,
                dy: 0,
              })
            ),

            // Lines
            ...(sys.length ? [Plot.line(sys, { x: "measured_at", y: "value", stroke: COLORS.sys, strokeWidth: 2.5, curve: "catmull-rom" })] : []),
            ...(dia.length ? [Plot.line(dia, { x: "measured_at", y: "value", stroke: COLORS.dia, strokeWidth: 2.5, curve: "catmull-rom" })] : []),
            ...(bpm.length ? [Plot.line(bpm, { x: "measured_at", y: "value", stroke: COLORS.bpm, strokeWidth: 2, strokeDasharray: "6,3", curve: "catmull-rom" })] : []),

            // Dots
            Plot.dot(series, {
              x: "measured_at", y: "value",
              fill: d => ({ Systolic: COLORS.sys, Diastolic: COLORS.dia, "Heart rate": COLORS.bpm })[d.series],
              r: 3, fillOpacity: 0.85, strokeWidth: 0,
            }),

            // Tooltip on hover
            Plot.tip(series, Plot.pointer({
              x: "measured_at", y: "value",
              title: d => `${d.series}: ${d.value}\n${d.measured_at.toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" })}`,
            })),
          ],
    })

    chart.querySelectorAll("[aria-label='y-grid'] line, [aria-label='x-grid'] line")
      .forEach(el => { el.style.stroke = "#e2e8f0"; el.style.strokeWidth = "1" })

    this.chartTarget.append(chart)
  }
}
