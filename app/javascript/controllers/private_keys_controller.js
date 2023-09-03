import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['blur']

  toggleValue(e) {
    e.currentTarget.classList.toggle(this.blurClass)
  }
}
