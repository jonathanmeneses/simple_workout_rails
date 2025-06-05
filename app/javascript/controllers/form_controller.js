import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
// Reusable form actions for auto-submit and other common form behaviors
export default class extends Controller {
  // Auto-submit form when called (e.g., on select change)
  autoSubmit() {
    this.element.requestSubmit()
  }
}