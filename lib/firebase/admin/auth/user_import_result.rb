module Firebase
  module Admin
    module Auth
      # Represents the result of a bulk user import operation.
      #
      # See UserManager#import_users method for more details.
      class UserImportResult
        # @return [Integer] The number of users successfully imported.
        attr_reader :success_count

        # @return [Integer] The number of users that failed to be imported.
        attr_reader :failure_count

        # @return [Array<ErrorInfo>] A list of ErrorInfo instances describing the errors encountered.
        attr_reader :errors

        # Initializes a new UserImportResult.
        #
        # @param [Integer] success_count The number of users successfully imported.
        # @param [Integer] failure_count The number of users that failed to be imported.
        # @param [Array<ErrorInfo>] errors A list of ErrorInfo instances describing the errors encountered.
        def initialize(success_count:, failure_count:, errors:)
          @success_count = success_count
          @failure_count = failure_count
          @errors = errors
        end

        # Creates a UserImportResult from a Firebase API response.
        #
        # @param [Hash] response_data The response data from the Firebase API.
        # @return [UserImportResult] A new UserImportResult instance.
        def self.from_api_response(response_data)
          errors = (response_data["error"] || []).map { |error| ErrorInfo.from_api_response(error) }
          
          new(
            success_count: response_data["successCount"] || 0,
            failure_count: response_data["failureCount"] || 0,
            errors: errors
          )
        end
      end
    end
  end
end 