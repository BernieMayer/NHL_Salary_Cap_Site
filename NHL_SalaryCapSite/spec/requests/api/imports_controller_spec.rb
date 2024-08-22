require 'rails_helper'
require 'rake'

# Load Rake tasks
Rails.application.load_tasks

RSpec.describe "API::Imports", type: :request do
  let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.json'), 'application/json') }

  before do
    # Mock the Rake task invocation
    allow(Rake::Task['import:contracts']).to receive(:invoke)
  end

  describe "POST /api/import_contracts" do
    context "when the request is authorized" do
      context "with a valid file" do
        it "calls the Rake task and returns a success message" do
          post '/api/import_contracts', params: { file: { io: file, filename: "sample.json" } }

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
  end
end
