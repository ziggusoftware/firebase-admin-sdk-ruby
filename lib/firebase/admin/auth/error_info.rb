module Firebase
  module Admin
    module Auth
      # Represents detailed error information for user import operations.
      class ErrorInfo
        # @return [Integer] The index of the user that caused the error.
        attr_reader :index

        # @return [String] The error message.
        attr_reader :message

        # Initializes a new ErrorInfo.
        #
        # @param [Integer] index The index of the user that caused the error.
        # @param [String] message The error message.
        def initialize(index:, message:)
          @index = index
          @message = message
        end

        # Creates an ErrorInfo from a Firebase API error response.
        #
        # @param [Hash] error_data The error data from the Firebase API.
        # @return [ErrorInfo] A new ErrorInfo instance.
        def self.from_api_response(error_data)
          new(
            index: error_data["index"],
            message: error_data["message"]
          )
        end
      end
    end
  end
end 