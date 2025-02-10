const { Application } = require("@hotwired/stimulus")
const TradeAnalyzerController = require("../../../app/javascript/controllers/trade_analyzer_controller")

describe("TradeAnalyzerController", () => {
  let application
  let element
  let controller

  beforeEach(() => {
    // Set up our document body with complete structure
    document.body.innerHTML = `
      <div data-controller="trade-analyzer">
        <select id="team1" data-trade-analyzer-target="teamSelect" data-target="team1-players">
          <option value="">Select Team</option>
          <option value="1">Test Team</option>
        </select>
        <div id="team1-players" data-trade-analyzer-target="playerList"></div>
        <div data-trade-analyzer-target="team1Label">Team 1 receives</div>
        <div data-trade-analyzer-target="team2Label">Team 2 receives</div>
        <div data-trade-analyzer-target="tradeDetails">
          <div class="bg-white"></div>
        </div>
      </div>
    `

    // Initialize Stimulus application
    application = Application.start()
    application.register("trade-analyzer", TradeAnalyzerController)
    
    element = document.querySelector('[data-controller="trade-analyzer"]')
    controller = application.getControllerForElementAndIdentifier(element, "trade-analyzer")

    // Mock fetch with simpler response
    global.fetch = jest.fn(() =>
      Promise.resolve({
        text: () => Promise.resolve(`
          <div class="relative">
            <input type="text" data-search-input>
            <div data-player-list>
              <div data-player-option data-player-name="Test Player">Test Player</div>
            </div>
          </div>
        `)
      })
    )
  })

  afterEach(() => {
    jest.restoreAllMocks()
  })

  it("loads players when team is selected", async () => {
    const select = element.querySelector('#team1')
    select.value = "1"
    select.dispatchEvent(new Event('change'))

    await new Promise(resolve => setTimeout(resolve, 100))
    expect(global.fetch).toHaveBeenCalledWith("/trade_analyzer/get_players?team_id=1")
  }, 10000)

  it("updates team label when team is selected", async () => {
    const select = element.querySelector('#team1')
    select.value = "1"
    select.dispatchEvent(new Event('change'))

    await new Promise(resolve => setTimeout(resolve, 100))
    console.log(controller)
    expect(controller.team2LabelTarget.textContent).toBe("Test Team receives")
  }, 10000)

  it("filters players when searching", async () => {
    // First load players
    const select = element.querySelector('#team1')
    select.value = "1"
    select.dispatchEvent(new Event('change'))
    
    // Wait for fetch and DOM update
    await new Promise(resolve => setTimeout(resolve, 100))
    
    // Then simulate search
    const searchInput = document.querySelector('[data-search-input]')
    searchInput.value = "Test"
    searchInput.dispatchEvent(new Event('input'))

    const playerOption = document.querySelector('[data-player-option]')
    expect(playerOption.classList.contains('hidden')).toBe(false)
  }, 10000)
}) 