# Pin npm packages by running ./bin/importmap

# Application, hotwire, turbo, stimulus
pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers', to: 'controllers'

# Channels/ActionCable
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'

# ActiveStorage
pin '@rails/activestorage', to: 'activestorage.esm.js'

# Bootstrap
pin 'bootstrap', to: 'bootstrap.min.js', preload: true
pin '@popperjs/core', to: 'https://unpkg.com/@popperjs/core@2', preload: true

# Trix
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin 'trix'

# Fora
pin 'fora'
