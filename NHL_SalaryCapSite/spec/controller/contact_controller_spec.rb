require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  describe "GET #contact" do
    it "returns a successful response" do
      get :contact
      expect(response).to have_http_status(:success)
    end

    it "renders the contact template" do
      get :contact
      expect(response).to render_template(:contact)
    end
  end
end
