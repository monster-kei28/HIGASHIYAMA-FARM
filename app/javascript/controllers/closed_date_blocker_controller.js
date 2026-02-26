import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { disabledDates: Array }
  static targets = ["input", "message"]

  connect() {
    this._hideTimer = null
  }

  disconnect() {
    if (this._hideTimer) clearTimeout(this._hideTimer)
  }

  check() {
    const picked = this.inputTarget.value // "YYYY-MM-DD"
    if (!picked) return

    if (this.disabledDatesValue.includes(picked)) {
      this.inputTarget.value = "" // 選択を解除
      this.showMessage("この日は休業日のため選択できません")
      return
    }

    this.hideMessage()
  }

  showMessage(text) {
    this.messageTarget.textContent = text
    this.messageTarget.classList.remove("hidden")

    if (this._hideTimer) clearTimeout(this._hideTimer)
    this._hideTimer = setTimeout(() => this.hideMessage(), 3000)
  }

  hideMessage() {
    this.messageTarget.classList.add("hidden")
  }
}