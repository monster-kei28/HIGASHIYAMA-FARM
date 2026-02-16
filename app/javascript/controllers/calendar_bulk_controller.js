import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  allOpen() {
    this.forEachEnabled((el) => { el.value = "open" })
  }

  allClosed() {
    this.forEachEnabled((el) => { el.value = "closed" })
  }

  clear() {
    this.forEachEnabled((el) => { el.value = "" })
  }

  weekendsClosed() {
    this.forEachEnabled((el) => {
      const day = this.weekday(el)
      if (day === null) return
      el.value = (day === 0 || day === 6) ? "closed" : ""
    })
  }

  weekdaysClosedWeekendsOpen() {
    this.forEachEnabled((el) => {
      const day = this.weekday(el)
      if (day === null) return
      el.value = (day === 0 || day === 6) ? "open" : "closed"
    })
  }

  // --- private helpers ---
  forEachEnabled(callback) {
    this.selectTargets.forEach((el) => {
      if (el.disabled) return
      callback(el)
    })
  }

  weekday(el) {
    const dateStr = el.dataset.date // "YYYY-MM-DD"
    if (!dateStr) return null

    const d = new Date(`${dateStr}T00:00:00`)
    if (Number.isNaN(d.getTime())) return null

    return d.getDay() // 0=Sun, 6=Sat
  }
}