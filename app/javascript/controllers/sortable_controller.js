import { Controller } from '@hotwired/stimulus'
import { patch } from '@rails/request.js'
import Sortable from 'sortablejs'

export default class extends Controller {
  static classes = ['ghost', 'filter']
  static values = { model: String }

  connect() {
    Sortable.create(this.element, {
      animation: 150,
      handle: '.handle',
      ghostClass: this.ghostClass,
      filter: `.${this.filterClass}`,
      onEnd: this._updatePosition.bind(this)
    })
  }

  _updatePosition(e) {
    if (e.newIndex == e.oldIndex) {
      return
    }

    const newPosition = e.newIndex + 1

    let body = {}
    body[this.modelValue] = { position: newPosition }

    patch(e.item.dataset.sortableUrl, {
      responseKind: 'turbo-stream',
      body: body
    })
  }
}
