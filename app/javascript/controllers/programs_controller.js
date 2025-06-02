import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "details", "viewModeTab", "content", "cycleSelector"]

    connect() {
        // Programs controller connected
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

    selectViewMode(event) {
        const viewMode = event.currentTarget.dataset.viewMode
        const programId = window.location.pathname.split('/').pop()
        const cycle = this.hasCycleSelectorTarget ? this.cycleSelectorTarget.value : null
        
        let url = `/programs/${programId}?view_mode=${viewMode}`
        if (cycle) {
            url += `&cycle=${encodeURIComponent(cycle)}`
        }
        
        window.location.href = url
    }

    selectCycle(event) {
        const cycle = event.currentTarget.value
        const programId = window.location.pathname.split('/').pop()
        const viewMode = 'program'
        
        const url = `/programs/${programId}?view_mode=${viewMode}&cycle=${encodeURIComponent(cycle)}`
        
        window.location.href = url
    }
} 