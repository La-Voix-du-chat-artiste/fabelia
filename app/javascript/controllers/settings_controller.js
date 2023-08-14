import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    chapterOptions: Object
  }

  connect() {
    this.element.style.height = `${this.element.scrollHeight}px`
    this.element.value = JSON.stringify(this.chapterOptionsValue, undefined, 2)
  }
}
