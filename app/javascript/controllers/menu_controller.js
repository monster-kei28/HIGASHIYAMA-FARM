import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // overlay を追加。button/icon は「残してもOK」だけど、最低限 panel/overlay が必要
  static targets = ["panel", "overlay", "button", "iconOpen", "iconClose"]

  connect() {
    this.close()

    this._onDocumentClick = this.onDocumentClick.bind(this)
    document.addEventListener("click", this._onDocumentClick)

    this._onKeydown = this.onKeydown.bind(this)
    document.addEventListener("keydown", this._onKeydown)
  }

  disconnect() {
    document.removeEventListener("click", this._onDocumentClick)
    document.removeEventListener("keydown", this._onKeydown)
  }

  toggle(event) {
    event?.stopPropagation()
    this.isOpen() ? this.close() : this.open()
  }

  open(event) {
    event?.stopPropagation()

    // スライドイン（translate-x-full を外す）
    this.panelTarget.classList.remove("translate-x-full")

    // オーバーレイ表示
    if (this.hasOverlayTarget) this.overlayTarget.classList.remove("hidden")

    // アイコン切り替え（存在すれば）
    if (this.hasIconOpenTarget) this.iconOpenTarget.classList.add("hidden")
    if (this.hasIconCloseTarget) this.iconCloseTarget.classList.remove("hidden")

    // aria
    if (this.hasButtonTarget) this.buttonTarget.setAttribute("aria-expanded", "true")
  }

  close(event) {
    event?.stopPropagation()

    // スライドアウト（translate-x-full を付ける）
    this.panelTarget.classList.add("translate-x-full")

    // オーバーレイ非表示
    if (this.hasOverlayTarget) this.overlayTarget.classList.add("hidden")

    // アイコン戻す（存在すれば）
    if (this.hasIconOpenTarget) this.iconOpenTarget.classList.remove("hidden")
    if (this.hasIconCloseTarget) this.iconCloseTarget.classList.add("hidden")

    // aria
    if (this.hasButtonTarget) this.buttonTarget.setAttribute("aria-expanded", "false")
  }

  isOpen() {
    // hidden じゃなくて translate-x-full で判定（スライド方式）
    return !this.panelTarget.classList.contains("translate-x-full")
  }

  onDocumentClick(event) {
    if (!this.isOpen()) return

    // メニュー内クリックは閉じない
    if (this.element.contains(event.target)) return

    // 外側クリックで閉じる
    this.close()
  }

  onKeydown(event) {
    if (!this.isOpen()) return
    if (event.key === "Escape") this.close()
  }
}