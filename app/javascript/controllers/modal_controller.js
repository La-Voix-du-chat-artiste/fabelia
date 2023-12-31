import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import { useHotkeys } from "stimulus-use/hotkeys"
import { fadeIn, fadeOut } from '../mixins/utils'

export default class extends Controller {
  static targets = ['prev', 'next']
  static values = {
    url: String // Base64 encoded
  }

  connect() {
    this.duration = 200

    fadeIn(this.element, this.duration)

    useClickOutside(this)

    useHotkeys(this, {
      'esc': [this.close],
      'left': [this._previous],
      'right': [this._next],
    })

    if (this.hasUrlValue) {
      const url = new URL(window.location)
      url.searchParams.set('modal', this.urlValue)

      window.history.pushState({ path: url.href }, '', url.href)
    }

    this.$title = document.querySelector('title')
    this.$metaOriginalTitle = document.querySelector('meta[name="original-page-title"]')

    // this._disableScroll()
  }

  close(e) {
    e.preventDefault()

    fadeOut(this.element, this.duration, () => {
      this.element.remove()
      this.$title.innerText = this.$metaOriginalTitle.content
    })

    if (this.hasUrlValue) {
      const url = new URL(window.location)
      url.searchParams.delete('modal')

      window.history.pushState({ path: url.href }, '', url.href)
    }

    // this._enableScroll()
  }

  clickOutside(e) {
    e.preventDefault()

    this.close(e)
  }

  _disableScroll() {
    document.body.classList.add('stop-scrolling')
  }

  _enableScroll() {
    document.body.classList.remove('stop-scrolling')
  }

  _previous(e) {
    if (this.hasPrevTarget) {
      this.prevTarget.click()
    }
  }

  _next(e) {
    if (this.hasNextTarget) {
      this.nextTarget.click()
    }
  }
}
