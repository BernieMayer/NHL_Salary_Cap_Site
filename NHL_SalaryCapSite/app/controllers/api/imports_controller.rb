require 'rake'

module Api
  class ImportsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def import_contracts
      if params[:file].present?
        # Save the uploaded file temporarily
        filename = params.dig(:file, :filename)
        file_path = Rails.root.join('tmp', filename)
        File.open(file_path, 'wb') do |file|
          file.write(params[:file][:io])
        end

        args = { file_path: file_path }
        Rails.application.load_tasks
        Rake::Task['import:contracts'].reenable # Ensure the task can be run multiple times
        Rake::Task['import:contracts'].invoke(args[:file_path]) # Pass the file path as an argument

        File.delete(file_path)

        # Respond with success message
        render json: { message: 'File imported successfully' }, status: :ok
      else
        render json: { error: 'No file provided' }, status: :unprocessable_entity
      end
    end
  end
end

