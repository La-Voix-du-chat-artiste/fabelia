import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    divId: String
  }

  jump(e) {
    e.preventDefault()

    const $jumpTo = document.getElementById(this.divIdValue)

    if (!$jumpTo) {
      return
    }

    window.scroll({
      behavior: 'smooth',
      left: 0,
      top: $jumpTo.offsetTop - 30
    })
  }
}
