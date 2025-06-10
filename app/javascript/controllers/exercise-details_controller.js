import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="exercise-details"
export default class extends Controller {
  static targets = ["panel", "toggleIcon"]

  toggle() {
    const panel = this.panelTarget
    const icon = this.toggleIconTarget
    
    if (panel.classList.contains("hidden")) {
      // Show details
      panel.classList.remove("hidden")
      icon.style.transform = "rotate(180deg)"
      
      // Smooth reveal animation
      panel.style.maxHeight = "0px"
      panel.style.overflow = "hidden"
      requestAnimationFrame(() => {
        panel.style.transition = "max-height 0.3s ease-out"
        panel.style.maxHeight = panel.scrollHeight + "px"
      })
      
      // Clean up after animation
      setTimeout(() => {
        panel.style.maxHeight = ""
        panel.style.overflow = ""
        panel.style.transition = ""
      }, 300)
      
    } else {
      // Hide details
      panel.style.maxHeight = panel.scrollHeight + "px"
      panel.style.overflow = "hidden"
      panel.style.transition = "max-height 0.3s ease-in"
      
      requestAnimationFrame(() => {
        panel.style.maxHeight = "0px"
      })
      
      setTimeout(() => {
        panel.classList.add("hidden")
        panel.style.maxHeight = ""
        panel.style.overflow = ""
        panel.style.transition = ""
      }, 300)
      
      icon.style.transform = "rotate(0deg)"
    }
  }
}