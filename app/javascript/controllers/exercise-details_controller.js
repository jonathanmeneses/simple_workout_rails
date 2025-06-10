import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="exercise-details"
export default class extends Controller {
  static targets = ["panel", "toggleIcon"]
  static values = { exerciseId: Number }

  connect() {
    // Check if this exercise should be expanded based on session storage
    const exerciseId = this.exerciseIdValue
    const isExpanded = sessionStorage.getItem(`exercise-${exerciseId}-expanded`) === "true"
    
    if (isExpanded) {
      this.showPanel(false) // Show without animation on page load
    }
  }

  toggle() {
    const panel = this.panelTarget
    const exerciseId = this.exerciseIdValue
    
    if (panel.classList.contains("hidden")) {
      this.showPanel(true)
      sessionStorage.setItem(`exercise-${exerciseId}-expanded`, "true")
    } else {
      this.hidePanel(true)
      sessionStorage.setItem(`exercise-${exerciseId}-expanded`, "false")
    }
  }

  showPanel(animate = true) {
    const panel = this.panelTarget
    const icon = this.toggleIconTarget
    
    panel.classList.remove("hidden")
    icon.style.transform = "rotate(180deg)"
    
    if (animate) {
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
    }
  }

  hidePanel(animate = true) {
    const panel = this.panelTarget
    const icon = this.toggleIconTarget
    
    if (animate) {
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
    } else {
      panel.classList.add("hidden")
    }
    
    icon.style.transform = "rotate(0deg)"
  }
}