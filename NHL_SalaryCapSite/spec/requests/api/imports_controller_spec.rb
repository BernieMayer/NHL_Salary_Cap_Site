require 'rails_helper'
require 'rake'

# Load Rake tasks
Rails.application.load_tasks

RSpec.describe "API::Imports", type: :request do
  let(:secret_key) { Rails.application.credentials.secret_key_base }
  let(:valid_token) { JWT.encode({ user_id: 1 }, secret_key, 'HS256') }
  let(:invalid_token) { 'invalid_token' }
  let(:headers) { { "Authorization" => "Bearer #{valid_token}" } }
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.json'), 'application/json') }

  before do
    # Mock the Rake task invocation
    allow(Rake::Task['import:contracts']).to receive(:invoke)
  end

  describe "POST /api/import_contracts" do
    context "when the request is authorized" do
      context "with a valid file" do
        it "calls the Rake task and returns a success message" do
          post '/api/import_contracts', params: { file: file }, headers: headers

          expect(Rake::Task['import:contracts']).to have_received(:invoke)
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('File imported successfully')
        end
      end

      context "without a file" do
        it "returns an error message" do
          post '/api/import_contracts', headers: headers

          expect(Rake::Task['import:contracts']).not_to have_received(:invoke)
          expect(response).to have_http_status(422) # Use the numeric status code for Unprocessable Entity
          expect(JSON.parse(response.body)['error']).to eq('No file provided')
        end
      end
    end

    context "when the request is unauthorized" do
      it "returns an unauthorized error when the token is missing" do
        post '/api/import_contracts'

        expect(Rake::Task['import:contracts']).not_to have_received(:invoke)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Authorization header missing')
      end

      it "returns an unauthorized error when the token is invalid" do
        post '/api/import_contracts', headers: { "Authorization" => "Bearer #{invalid_token}" }

        expect(Rake::Task['import:contracts']).not_to have_received(:invoke)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
