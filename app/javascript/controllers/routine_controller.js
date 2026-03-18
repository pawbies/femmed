import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="routine"
export default class extends Controller {
  static targets = ["interval", "hourly", "weekly", "times", "timesList", "startDate", "submit"]

  toggle() {
    const checked = this.element.querySelector('input[name="routine_type"]:checked')
    const val = checked ? checked.value : ""

    this.intervalTarget.classList.toggle("hidden", val !== "interval")
    this.hourlyTarget.classList.toggle("hidden", val !== "hourly")
    this.weeklyTarget.classList.toggle("hidden", val !== "weekly")
    this.timesTarget.classList.toggle("hidden", val === "hourly" || val === "")
    this.startDateTarget.classList.toggle("hidden", val === "")
    this.submitTarget.classList.toggle("hidden", val === "")
  }

  addTime() {
    const div = document.createElement("div")
    div.className = "flex gap-2 items-center"
    div.innerHTML = `
      <input type="time" name="routine_times[]" value="12:00"
             class="shadow-sm rounded-lg border bg-rose-50 border-rose-300 px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-rose-300">
      <button type="button" data-action="click->routine#removeTime"
              class="text-zinc-400 hover:text-red-400 text-xl leading-none cursor-pointer">&times;</button>
    `
    this.timesListTarget.appendChild(div)
  }

  removeTime(e) {
    e.target.closest("div").remove()
  }
}
