// app/javascript/controllers/teams_combo_box_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "list"];

  filter() {
    const query = this.inputTarget.value.trim();

    if (query.length < 2) { // Avoid searching for very short inputs
      this.hideList();
      return;
    }

    fetch(`/teams/search?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.listTarget.innerHTML = ""; // Clear existing list
        if (data.length > 0) {
          data.forEach(team => {
            const li = document.createElement("li");
            const link = document.createElement("a");
            link.textContent = team.name;
            link.href = team.url;
            link.classList.add("block", "px-4", "py-2", "hover:bg-gray-100");
            li.appendChild(link);
            this.listTarget.appendChild(li);
          });
          this.showList();
        } else {
          this.hideList(); // Hide the list if no results
        }
      });
  }

  select(event) {
    const value = event.target.dataset.value;
    this.inputTarget.value = value;
    this.hideList();
  }

  hideList() {
    this.listTarget.style.display = "none";
  }

  showList() {
    this.listTarget.style.display = "block";
  }
}
