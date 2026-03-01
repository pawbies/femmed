import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "backdrop", "sidebar"]

  open() {
    this.sidebarTarget.classList.remove("hidden")
    setTimeout(() => {
      this.drawerTarget.classList.remove("-translate-x-full")
      this.backdropTarget.classList.remove("opacity-0")
      this.backdropTarget.classList.add("opacity-100")
    }, 10)
  }

  close() {
    this.drawerTarget.classList.add("-translate-x-full")
    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")
    setTimeout(() => {
      this.sidebarTarget.classList.add("hidden")
    }, 300)
  }
}
