import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    console.log("PlayerSearchController connected");
  }

  async search() {
    const query = this.inputTarget.value.trim();

    if (query.length === 0) {
      this.resultsTarget.innerHTML = ""; // Clear results when input is empty
      return;
    }

    try {
      const response = await fetch(`/player_search?query=${encodeURIComponent(query)}`);

      if (!response.ok) {
        throw new Error("Failed to fetch players");
      }

      const players = await response.json();
      this.resultsTarget.innerHTML = ""; // Clear existing results

      if (players.length === 0) {
        this.resultsTarget.innerHTML = `<li class="p-2 text-gray-500">No results found</li>`;
      } else {
        players.slice(0,10).forEach((player) => {
          const listItem = document.createElement("li");
          listItem.classList.add(
            "p-2",
            "border-b",
            "border-gray-300",
            "rounded-lg",
            "hover:bg-gray-100",
            "transition-all",
            "duration-200"
          );

          const playerLink = document.createElement("a");
          playerLink.href = `/players/${player.slug}`;
          playerLink.textContent = player.name;
          playerLink.classList.add("block", "text-gray-800", "font-medium", "hover:text-blue-600");

          listItem.appendChild(playerLink);
          this.resultsTarget.appendChild(listItem);
        });
      }
    } catch (error) {
      console.error("Error fetching player data:", error);
    }
  }
}
