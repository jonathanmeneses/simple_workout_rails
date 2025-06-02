import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "details"]

    connect() {
        // Optionally, set the default tab if needed
    }

    selectTab(event) {
        const selectedTab = event.currentTarget.dataset.tab
        console.log(selectedTab)
        this.tabTargets.forEach(tab => {
            if (tab.dataset.tab === selectedTab) {
                tab.classList.add('bg-gray-100')
            } else {
                tab.classList.remove('bg-gray-100')
            }
        })
        this.detailsTargets.forEach(details => {
            if (details.dataset.details === selectedTab) {
                details.classList.remove('hidden')
            } else {
                details.classList.add('hidden')
            }
        })
    }
} 