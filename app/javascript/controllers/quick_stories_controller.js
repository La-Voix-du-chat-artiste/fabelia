import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.cookieName = 'hide_quick_story'

    if(this._getCookie(this.cookieName)) {
      this.element.removeAttribute('open')
    }
  }

  setCookie() {
    if(this._getCookie(this.cookieName)) {
      // Delete the cookie
      document.cookie = `${this.cookieName}=true; max-age=0;`;
    } else {
      // Set the cookie
      document.cookie = `${this.cookieName}=true;`
    }
  }

  _getCookie (name) {
    let value = `; ${document.cookie}`
    let parts = value.split(`; ${name}=`)

    if (parts.length === 2) {
      return parts.pop().split(';').shift()
    }
  }
}
