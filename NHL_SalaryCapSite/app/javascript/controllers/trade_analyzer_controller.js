import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "teamSelect", 
    "playerList", 
    "searchInput", 
    "selectedPlayers", 
    "team1Label", 
    "team2Label",
    "tradeDetails",
    "draftPicks",
    "selectedDraftPicks"
  ]

  connect() {
    this.initializeTeamSelects()
  }

  initializeTeamSelects() {
    const teamSelects = this.element.querySelectorAll('select[id^="team"]');
  
    teamSelects.forEach(select => {
      select.addEventListener('change', (e) => {
        this.loadPlayers(e.target);
        this.updateTeamOptions();
      });
    });
  }
  
  updateTeamOptions() {
    const teamSelects = this.element.querySelectorAll('select[id^="team"]');
    const selectedTeams = new Set(
      Array.from(teamSelects).map(select => select.value).filter(value => value)
    );
  
    teamSelects.forEach(select => {
      const currentValue = select.value;
      Array.from(select.options).forEach(option => {
        option.disabled = selectedTeams.has(option.value) && option.value !== currentValue;
      });
    });
  }
  

  loadPlayers(select) {
    const teamId = select.value
    const playersDiv = document.getElementById(select.dataset.target)
    const isTeam1 = select.id.includes('team1')
    const currentTeamNumber = isTeam1 ? '1' : '2'
    const receivingTeamNumber = isTeam1 ? '2' : '1'
    
    if (teamId) {
      const teamName = select.options[select.selectedIndex].text
      this[`team${receivingTeamNumber}LabelTarget`].textContent = `${teamName} receives`

      fetch(`/trade_analyzer/get_players?team_id=${teamId}`)
        .then(response => response.text())
        .then(html => {
          playersDiv.innerHTML = html
          this.initializePlayerSelects()
        })

        fetch(`/trade_analyzer/get_draft_picks?team_id=${teamId}`)
          .then(response => response.text())
          .then(html => {
            const draftPicksDiv = document.getElementById(`team${currentTeamNumber}-draft-picks`)
            draftPicksDiv.innerHTML = html
          })
    } else {
      playersDiv.innerHTML = ''
      this[`team${receivingTeamNumber}LabelTarget`].textContent = `Team ${receivingTeamNumber} receives`
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
          const playerId = option.dataset.playerId;

          // Prevent duplicate selection
          const alreadySelected = selectedPlayersDiv.querySelector(`[data-player-id="${playerId}"]`);
          if (alreadySelected) return;

          const playerDiv = document.createElement('div')
          playerDiv.className = 'flex justify-between items-center p-1 bg-gray-50 rounded shadow-sm'
          playerDiv.dataset.playerId = playerId
          playerDiv.innerHTML = `
            <div class="">
              <span class="text-xs font-medium">${option.dataset.playerName}</span>
              <span class="ml-2 text-xs text-gray-600">$${option.dataset.playerCapHit}</span>
            </div>
            <button type="button" class="ml-2 text-red-500 hover:text-red-700 text-lg font-bold" 
                    data-action="click->trade-analyzer#removePlayer">
              ×
            </button>
          `
          selectedPlayersDiv.appendChild(playerDiv)
          
          newSearchInput.value = '';
          newList.classList.add('hidden')
        })
      })
    })
  }

   removePlayer(event) {
    event.target.closest('div').remove();
  }

  toggleDraftPick(event) {
    const pickId = event.target.dataset.pickId
    const pickYear = event.target.dataset.pickYear
    const pickRound = event.target.dataset.pickRound
    const pickTeam = event.target.dataset.pickTeam
    const teamNumber = event.target.closest('[id^="team"]').id.includes('team1') ? '1' : '2'
    const selectedDraftPicksDiv = document.getElementById(`team${teamNumber}-selected-draft-picks`)

   // if a pick is already selected, remove it by the data set attribute
   const draftPick = selectedDraftPicksDiv.querySelector(`[data-pick-id="${pickId}"]`);

  
   if (draftPick) {
      // remove the pick from the DOM
      console.log("The draft pick is", draftPick)
      draftPick.closest('div').remove();
      return;
   }
    

    const pickDiv = document.createElement('div')
    pickDiv.className = 'flex justify-between items-center p-1 bg-gray-50 rounded shadow-sm'
    pickDiv.dataset.pickId = pickId
    pickDiv.innerHTML = `
      <div class="flex-1">
        <span class="text-xs font-medium">${pickTeam} ${pickYear} Round ${pickRound} </span>
      </div>
      <button type="button" class="ml-2 text-red-500 hover:text-red-700 text-lg font-bold" 
              data-action="click->trade-analyzer#removeDraftPick">
        ×
      </button>
    `

    selectedDraftPicksDiv.appendChild(pickDiv)      
  }

  removeDraftPick(event) {
    event.target.closest('div').remove();
  }

  downloadTradeImage() {
    const element = this.tradeDetailsTarget.querySelector('.bg-white')
    
    html2canvas(element, {
      backgroundColor: 'white',
      scale: 2,
      logging: false,
      useCORS: true,
      padding: 20,
      margin: 20,
      windowWidth: 1200,
      windowHeight: 800
    }).then(canvas => {
      const link = document.createElement('a')
      link.download = 'trade-details.png'
      link.href = canvas.toDataURL('image/png')
      link.click()
    })
  }
} 