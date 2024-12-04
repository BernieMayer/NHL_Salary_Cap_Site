import { Application } from "@hotwired/stimulus"
import 'controllers/player_search_controller';


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
