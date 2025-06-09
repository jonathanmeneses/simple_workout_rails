import { Controller } from "@hotwired/stimulus"

// This controller manages the equipment selection UI interactions
export default class extends Controller {
  // Define which HTML elements this controller needs to interact with
  static targets = [
    "noEquipment",    // The "No equipment" checkbox
    "equipmentGrid",  // The container holding all equipment checkboxes  
    "equipmentBox",   // Individual equipment checkboxes (multiple)
    "statusText"      // The status display text
  ]

  // This runs when the controller connects to the DOM
  connect() {
    console.log("Equipment controller connected!")
    this.updateStatus()
  }

  // Called when "No equipment" checkbox is toggled
  toggleNoEquipment() {
    const isNoEquipment = this.noEquipmentTarget.checked
    
    if (isNoEquipment) {
      // Visual feedback: gray out and disable equipment grid
      this.equipmentGridTarget.classList.add("opacity-50", "pointer-events-none")
      
      // Don't uncheck equipment boxes (preserve user's selection for later)
      // This is the key UX insight - save their equipment preferences!
      
    } else {
      // Re-enable equipment grid
      this.equipmentGridTarget.classList.remove("opacity-50", "pointer-events-none")
    }
    
    this.updateStatus()
  }

  // Called when "All Equipment" button is clicked
  selectAllEquipment(event) {
    event.preventDefault() // Don't submit the form
    
    // Uncheck "No equipment" first
    this.noEquipmentTarget.checked = false
    
    // Check all individual equipment boxes
    this.equipmentBoxTargets.forEach(checkbox => {
      checkbox.checked = true
    })
    
    // Re-enable equipment grid if it was disabled
    this.equipmentGridTarget.classList.remove("opacity-50", "pointer-events-none")
    
    this.updateStatus()
  }

  // Called when any individual equipment checkbox changes
  updateEquipmentSelection() {
    // If user manually selects equipment, uncheck "No equipment"
    if (this.noEquipmentTarget.checked) {
      this.noEquipmentTarget.checked = false
      this.equipmentGridTarget.classList.remove("opacity-50", "pointer-events-none")
    }
    
    this.updateStatus()
  }

  // Update the status text to reflect current selection
  updateStatus() {
    const isNoEquipment = this.noEquipmentTarget.checked
    const selectedEquipment = this.equipmentBoxTargets.filter(cb => cb.checked)
    
    let statusText = ""
    
    if (isNoEquipment) {
      statusText = "Bodyweight exercises only"
    } else if (selectedEquipment.length === this.equipmentBoxTargets.length) {
      statusText = "All equipment available"
    } else if (selectedEquipment.length > 0) {
      const names = selectedEquipment.map(cb => cb.value.replace('_', ' '))
      statusText = `Selected: ${names.join(', ')}`
    } else {
      statusText = "All equipment available"
    }
    
    if (this.hasStatusTextTarget) {
      this.statusTextTarget.textContent = statusText
    }
  }
}