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
  togglePromptSystem(e) {
    e.preventDefault()

    const selected = e.target.value
    const $completeText = document.getElementById('extra_complete_text')
    const $dropperText = document.getElementById('extra_dropper_text')

    if (selected == 'dropper') {
      $completeText.classList.add('hidden')
      $dropperText.classList.remove('hidden')
    } else if (selected == 'complete') {
      $completeText.classList.remove('hidden')
      $dropperText.classList.add('hidden')
    }
  }
}
