document.addEventListener('DOMContentLoaded', () => {
    initializePlayerSearch();
  });
  
  document.addEventListener('turbo:load', () => {
    // Re-initialize the search component when the page is dynamically loaded or updated (with Turbo)
    initializePlayerSearch();
  });
  
  function initializePlayerSearch() {
    // Find all elements with the class `player-search-input` to handle multiple instances
    const searchInputs = document.querySelectorAll('.player-search-input');
  
    searchInputs.forEach(input => {
      // Find the corresponding list element for each input (assuming the list is the next sibling)
      const list = input.nextElementSibling;
  
      if (!list) {
        console.error('No list found for the input');
        return;
      }
  
      // Attach the event listener to the input field
      input.addEventListener('input', async () => {
        const query = input.value.trim(); // Get the trimmed input value
  
        if (query.length === 0) {
          list.innerHTML = ''; // Clear the list if input is empty
          return;
        }
  
        try {
          const response = await fetch(`/players/search?query=${encodeURIComponent(query)}`);
  
          if (!response.ok) {
            throw new Error('Error fetching player data');
          }
  
          const players = await response.json();
  
          // Limit the results to the first 10 players
          const limitedPlayers = players.slice(0, 10);
  
          // Clear previous search results
          list.innerHTML = '';
  
          if (limitedPlayers.length === 0) {
            const noResultsItem = document.createElement('li');
            noResultsItem.textContent = 'No results found';
            noResultsItem.classList.add('p-2', 'text-gray-500');
            list.appendChild(noResultsItem);
          } else {
            // Display the player names in the list as clickable links
            limitedPlayers.forEach(player => {
              const listItem = document.createElement('li');
              listItem.classList.add('p-2', 'border-b', 'border-gray-300', 'rounded-lg', 'hover:bg-gray-100', 'transition-all', 'duration-200');
  
              const playerLink = document.createElement('a');
              playerLink.href = `/players/${player.slug}`; // Use the player's slug in the URL
              playerLink.textContent = player.name;
              playerLink.classList.add('block', 'text-gray-800', 'font-medium', 'hover:text-blue-600');
  
              listItem.appendChild(playerLink);
              list.appendChild(listItem);
            });
          }
        } catch (error) {
          console.error('Error fetching player data:', error);
        }
      });
    });
  }
  