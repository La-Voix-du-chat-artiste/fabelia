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
}
