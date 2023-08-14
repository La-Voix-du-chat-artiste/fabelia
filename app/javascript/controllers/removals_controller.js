import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    disappear: { type: Boolean, default: true }
  }

  remove() {
    if (this.disappearValue) {
      this.element.remove()
    }
  }

  forceRemove(e) {
    e.preventDefault()

    this.disappearValue = true
    this.element.classList.add('fade-out')
  }
}
