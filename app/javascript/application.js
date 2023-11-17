// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from '@hotwired/turbo'
import 'controllers'
import TurboPower from 'turbo_power'

TurboPower.initialize(Turbo.StreamActions)

// @see https://gorails.com/episodes/custom-hotwire-turbo-confirm-modals
Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById('turbo-confirm')

  dialog.querySelector('p').textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener('close', () => {
      resolve(dialog.returnValue == 'confirm')
    }, { once: true })
  })
})
