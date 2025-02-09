import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["teamSelect", "playerList", "searchInput", "selectedPlayers"]

  connect() {
    this.initializeTeamSelects()
  }

  initializeTeamSelects() {
    const teamSelects = this.element.querySelectorAll('select[id^="team"]')
    
    teamSelects.forEach(select => {
      select.addEventListener('change', (e) => this.loadPlayers(e.target))
    })
  }

  loadPlayers(select) {
    const teamId = select.value
    const playersDiv = document.getElementById(select.dataset.target)
    
    if (teamId) {
      fetch(`/trade_analyzer/get_players?team_id=${teamId}`)
        .then(response => response.text())
        .then(html => {
          playersDiv.innerHTML = html
          this.initializePlayerSelects()
        })
    } else {
      playersDiv.innerHTML = ''
    }
  }

  initializePlayerSelects() {
    const playerLists = document.querySelectorAll('[data-player-list]')
    
    playerLists.forEach(list => {
      // Remove existing event listeners by cloning and replacing the elements
      const searchInput = list.previousElementSibling
      const newSearchInput = searchInput.cloneNode(true)
      searchInput.parentNode.replaceChild(newSearchInput, searchInput)
      
      const newList = list.cloneNode(true)
      list.parentNode.replaceChild(newList, list)
      
      const options = newList.querySelectorAll('[data-player-option]')
      
      // Show/hide dropdown on input focus/blur
      newSearchInput.addEventListener('focus', () => {
        newList.classList.remove('hidden')
      })

      // Handle clicking outside
      document.addEventListener('click', (e) => {
        if (!newList.contains(e.target) && !newSearchInput.contains(e.target)) {
          newList.classList.add('hidden')
        }
      })

      // Filter players as user types
      newSearchInput.addEventListener('input', (e) => {
        const searchText = e.target.value.toLowerCase()
        
        options.forEach(option => {
          const playerName = option.dataset.playerName.toLowerCase()
          if (playerName.includes(searchText)) {
            option.classList.remove('hidden')
          } else {
            option.classList.add('hidden')
          }
        })
      })

      // Handle player selection
      options.forEach(option => {
        option.addEventListener('click', () => {
          const teamNumber = newList.closest('[id^="team"]').id.includes('team1') ? '1' : '2'
          const selectedPlayersDiv = document.getElementById(`team${teamNumber}-selected-players`)
          
          const playerDiv = document.createElement('div')
          playerDiv.className = 'flex justify-between items-center p-2 bg-gray-50 rounded'
          playerDiv.innerHTML = `
            <span>${option.dataset.playerName} - $${option.dataset.playerCapHit}</span>
            <button type="button" class="text-red-500 hover:text-red-700" 
                    onclick="removePlayer('${teamNumber}', '${option.dataset.playerId}', this)">
              ×
            </button>
          `
          selectedPlayersDiv.appendChild(playerDiv)
          
          // Reset search and hide dropdown
          newSearchInput.value = ''
          newList.classList.add('hidden')
        })
      })
    })
  }

  removePlayer(teamNumber, playerId, button) {
    button.closest('div').remove()
  }
} 