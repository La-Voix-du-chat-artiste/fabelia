# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin '@rails/request.js', to: 'https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js'
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
pin 'slim-select', to: 'https://ga.jspm.io/npm:slim-select@2.5.1/dist/slimselect.es.js'

pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.52.0/dist/index.js'
pin 'stimulus-use/hotkeys', to: 'https://ga.jspm.io/npm:stimulus-use@0.52.0/dist/hotkeys.js'
pin 'hotkeys-js', to: 'https://ga.jspm.io/npm:hotkeys-js@3.12.0/dist/hotkeys.esm.js'

pin 'turbo_power', to: 'https://ga.jspm.io/npm:turbo_power@0.6.0/dist/turbo_power.js'

pin 'flowbite', to: 'https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.turbo.min.js'
