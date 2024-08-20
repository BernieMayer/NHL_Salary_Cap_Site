require 'rake'

module Api
  class ImportsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_request

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

    private

    def authorize_request
      Rails.logger.info "Request details: #{request.inspect}"
      auth_header = request.headers['Authorization']
      if auth_header.present?
        token = auth_header.split(' ').last
        Rails.logger.info "Authorization header: #{auth_header}"
        Rails.logger.info "Token: #{token}"
    
        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
          Rails.logger.info "Decoded Token: #{decoded_token}"
          # Handle decoded_token as needed
        rescue JWT::DecodeError => e
          Rails.logger.error "JWT Decode Error: #{e.message}"
          render json: { error: 'Unauthorized' }, status: :unauthorized
        rescue StandardError => e
          Rails.logger.error "General Error: #{e.message}"
          render json: { error: 'Internal server error' }, status: :internal_server_error
        end
      else
        render json: { error: 'Authorization header missing' }, status: :unauthorized
      end
    end    
  end
end

