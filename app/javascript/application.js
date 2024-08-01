// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Stimulus / Turbo
import "@hotwired/turbo-rails"
import "controllers"

// ActiveStorage
import "@rails/activestorage"

// Trix
import "trix"

document.addEventListener("trix-before-initialize", () => {
  // Before Trix init...
})

// Boostrap 5+
import "@popperjs/core"
import "bootstrap"
import * as bootstrap from "bootstrap"

// Fora
import 'fora';