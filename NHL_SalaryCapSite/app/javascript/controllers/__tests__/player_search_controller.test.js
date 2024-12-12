/**
 * @jest-environment jsdom
 */

import { Application } from "@hotwired/stimulus";
import PlayerSearchController from "./player_search_controller"; // Update this path as needed

describe("PlayerSearchController", () => {
  let application;
  let inputElement;
  let resultsElement;

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="player-search">
        <input data-player-search-target="input" />
        <ul data-player-search-target="results"></ul>
      </div>
    `;

    application = Application.start();
    application.register("player-search", PlayerSearchController);

    inputElement = document.querySelector('[data-player-search-target="input"]');
    resultsElement = document.querySelector('[data-player-search-target="results"]');
  });

  afterEach(() => {
    application.stop();
    jest.resetAllMocks();
  });

  test("clears results when input is empty", async () => {
    inputElement.value = "";
    inputElement.dispatchEvent(new Event("input", { bubbles: true }));

    // Wait for DOM updates
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(resultsElement.innerHTML).toBe("");
  });

  test("displays 'No results found' when no players are returned", async () => {
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve([]),
      })
    );

    inputElement.value = "Unknown";
    inputElement.dispatchEvent(new Event("input", { bubbles: true }));

    // Wait for DOM updates
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(resultsElement.innerHTML).toBe(
      `<li class="p-2 text-gray-500">No results found</li>`
    );
  });

  test("renders player results when players are returned", async () => {
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () =>
          Promise.resolve([
            { name: "Connor McDavid", slug: "connor-mcdavid" },
            { name: "Sidney Crosby", slug: "sidney-crosby" },
          ]),
      })
    );

    inputElement.value = "Connor";
    inputElement.dispatchEvent(new Event("input", { bubbles: true }));

    // Wait for DOM updates
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(resultsElement.children.length).toBe(2);

    const firstPlayer = resultsElement.children[0];
    expect(firstPlayer.querySelector("a").textContent).toBe("Connor McDavid");
    expect(firstPlayer.querySelector("a").href).toContain("/players/connor-mcdavid");

    const secondPlayer = resultsElement.children[1];
    expect(secondPlayer.querySelector("a").textContent).toBe("Sidney Crosby");
    expect(secondPlayer.querySelector("a").href).toContain("/players/sidney-crosby");
  });

  test("handles fetch errors gracefully", async () => {
    console.error = jest.fn(); // Mock console.error to suppress error logs

    global.fetch = jest.fn(() => Promise.reject(new Error("Network error")));

    inputElement.value = "Connor";
    inputElement.dispatchEvent(new Event("input", { bubbles: true }));

    // Wait for DOM updates
    await new Promise((resolve) => setTimeout(resolve, 10));

    expect(console.error).toHaveBeenCalledWith(
      "Error fetching player data:",
      expect.any(Error)
    );
    expect(resultsElement.innerHTML).toBe("");
  });
});
