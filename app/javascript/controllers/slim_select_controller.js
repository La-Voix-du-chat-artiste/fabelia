import { Controller } from '@hotwired/stimulus'
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = {
    showSearch: { type: Boolean, default: true },
    closeOnSelect: { type: Boolean, default: true }
  }

  connect() {
    new SlimSelect({
      select: this.element,
      settings: {
        showSearch: this.showSearchValue,
        searchPlaceholder: 'Rechercher',
        searchText: 'Pas de résultat',
        searchingText: 'Recherche en cours...',
        placeholderText: 'Sélectionner une option',
        closeOnSelect: this.closeOnSelectValue,
        allowDeselect: true
      }
    })
  }

  // Specific action used in story form
  toggleStoryFormFields(e) {
    e.preventDefault()

    const selected = e.target.value
    const $completeText = document.getElementById('extra_complete_text')
    const $dropperText = document.getElementById('extra_dropper_text')

    const $storyOptionsMinimumPollSats = document.querySelector('.story_options_minimum_poll_sats')
    const $storyOptionsMaximumPollSats = document.querySelector('.story_options_maximum_poll_sats')

    if (selected == 'dropper') {
      $completeText.classList.add('hidden')
      $dropperText.classList.remove('hidden')

      $storyOptionsMinimumPollSats.classList.remove('hidden')
      $storyOptionsMaximumPollSats.classList.remove('hidden')
      $storyOptionsMinimumPollSats.setAttribute('disabled', false)
      $storyOptionsMaximumPollSats.setAttribute('disabled', false)

    } else if (selected == 'complete') {
      $completeText.classList.remove('hidden')
      $dropperText.classList.add('hidden')

      $storyOptionsMinimumPollSats.classList.add('hidden')
      $storyOptionsMaximumPollSats.classList.add('hidden')
      $storyOptionsMinimumPollSats.setAttribute('disabled', true)
      $storyOptionsMaximumPollSats.setAttribute('disabled', true)
    }
  }
}
