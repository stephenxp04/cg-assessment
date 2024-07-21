import "@hotwired/turbo-rails"
import { Turbo } from "@hotwired/turbo-rails"

// Initialize Turbo
Turbo.session.drive = true

console.log("Application.js is loaded and running");

import { StreamActions } from "@hotwired/turbo"
StreamActions.after.renderTemplate = (element) => {
  console.log("Turbo Stream rendered:", element)
}

import "./controllers"
