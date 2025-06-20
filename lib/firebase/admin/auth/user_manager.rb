module Firebase
  module Admin
    module Auth
      # Base url for the Google Identity Toolkit
      ID_TOOLKIT_URL = "https://identitytoolkit.googleapis.com/v1"

      # Provides methods for interacting with the Google Identity Toolkit
      class UserManager
        # Initializes a UserManager.
        #
        # @param [String] project_id The Firebase project id.
        # @param [Credentials] credentials The credentials to authenticate with.
        # @param [String, nil] url_override The base url to override with.
        def initialize(project_id, credentials, url_override = nil)
          uri = "#{url_override || ID_TOOLKIT_URL}/"
          @project_id = project_id
          @client = Firebase::Admin::Internal::HTTPClient.new(uri: uri, credentials: credentials)
        end

        # Creates a new user account with the specified properties.
        #
        # @param [String, nil] uid The id to assign to the newly created user.
        # @param [String, nil] display_name The user's display name.
        # @param [String, nil] email The user's primary email.
        # @param [Boolean, nil] email_verified A boolean indicating whether or not the user's primary email is verified.
        # @param [String, nil] phone_number The user's primary phone number.
        # @param [String, nil] photo_url The user's photo URL.
        # @param [String, nil] password The user's raw, unhashed password.
        # @param [Boolean, nil] disabled A boolean indicating whether or not the user account is disabled.
        #
        # @raise [CreateUserError] if a user cannot be created.
        #
        # @return [UserRecord]
        def create_user(uid: nil, display_name: nil, email: nil, email_verified: nil, phone_number: nil, photo_url: nil, password: nil, disabled: nil)
          payload = {
            localId: validate_uid(uid),
            displayName: validate_display_name(display_name),
            email: validate_email(email),
            phoneNumber: validate_phone_number(phone_number),
            photoUrl: validate_photo_url(photo_url),
            password: validate_password(password),
            emailVerified: to_boolean(email_verified),
            disabled: to_boolean(disabled)
          }.compact
          res = @client.post(with_path("accounts"), payload).body
          uid = res&.fetch("localId")
          raise CreateUserError, "failed to create user #{res}" if uid.nil?
          get_user_by(uid: uid)
        end

        # Gets the user corresponding to the provided key
        #
        # @param [Hash] query Query parameters to search for a user by.
        # @option query [String] :uid A user id.
        # @option query [String] :email An email address.
        # @option query [String] :phone_number A phone number.
        #
        # @return [UserRecord] A user or nil if not found
        def get_user_by(query)
          if (uid = query[:uid])
            payload = {localId: Array(validate_uid(uid, required: true))}
          elsif (email = query[:email])
            payload = {email: Array(validate_email(email, required: true))}
          elsif (phone_number = query[:phone_number])
            payload = {phoneNumber: Array(validate_phone_number(phone_number, required: true))}
          else
            raise ArgumentError, "Unsupported query: #{query}"
          end
          res = @client.post(with_path("accounts:lookup"), payload).body
          users = res["users"] if res
          UserRecord.new(users[0]) if users.is_a?(Array) && users.length > 0
        end

        # Deletes the user corresponding to the specified user id.
        #
        # @param [String] uid
        #   The id of the user.
        def delete_user(uid)
          @client.post(with_path("accounts:delete"), {localId: validate_uid(uid, required: true)})
        end

        # Updates an existing user account with the specified properties.
        #
        # @param [String] uid The id of the user to update.
        # @param [String, nil] display_name The user's display name.
        # @param [String, nil] email The user's primary email.
        # @param [Boolean, nil] email_verified A boolean indicating whether or not the user's primary email is verified.
        # @param [String, nil] phone_number The user's primary phone number.
        # @param [String, nil] photo_url The user's photo URL.
        # @param [String, nil] password The user's raw, unhashed password.
        # @param [Boolean, nil] disabled A boolean indicating whether or not the user account is disabled.
        #
        # @raise [ArgumentError] if the uid is invalid.
        # @raise [Error] if the user cannot be updated.
        #
        # @return [UserRecord]
        def update_user(uid:, display_name: nil, email: nil, email_verified: nil, phone_number: nil, photo_url: nil, password: nil, disabled: nil)
          payload = {
            localId: validate_uid(uid, required: true),
            displayName: validate_display_name(display_name),
            email: validate_email(email),
            phoneNumber: validate_phone_number(phone_number),
            photoUrl: validate_photo_url(photo_url),
            password: validate_password(password),
            emailVerified: to_boolean(email_verified),
            disabled: to_boolean(disabled)
          }.compact

          @client.post(with_path("accounts:update"), payload)
          get_user_by(uid: uid)
        end

        def create_session_cookie(id_token, valid_duration = 432000)
          payload = {
            idToken: id_token,
            validDuration: valid_duration
          }
          @client.post("projects/#{@project_id}:createSessionCookie", payload).body
        end

        # Generates a password reset link for the user with the specified email address.
        #
        # @param [String] email The email address of the user whose password is to be reset.
        # @param [Hash] action_code_settings Optional settings for the password reset link.
        # @option action_code_settings [String] :url The URL to redirect to after the password reset.
        # @option action_code_settings [Boolean] :handle_code_in_app Whether to handle the code in the app.
        #
        # @return [String] The generated password reset link.
        def generate_password_reset_link(email, action_code_settings = {})
          validate_email(email, required: true)
          
          payload = {
            requestType: "PASSWORD_RESET",
            email: email,
            returnOobLink: true
          }

          if action_code_settings.any?
            payload[:actionCodeSettings] = {
              url: action_code_settings[:url],
              handleCodeInApp: action_code_settings[:handle_code_in_app]
            }.compact
          end

          response = @client.post(with_path("accounts:sendOobCode"), payload).body
          response["oobLink"]
        end

        # Imports the specified list of users into Firebase Auth.
        #
        # At most 1000 users can be imported at a time. This operation is optimized for bulk imports
        # and ignores checks on identifier uniqueness, which could result in duplications. The
        # hash_alg parameter must be specified when importing users with passwords.
        #
        # @param [Array<ImportUserRecord>] users A list of ImportUserRecord instances to import.
        #   Length of the list must not exceed 1000.
        # @param [UserImportHash, nil] hash_alg A UserImportHash object (optional). Required when
        #   importing users with passwords.
        #
        # @raise [ArgumentError] If the users array is invalid or exceeds 1000 users.
        # @raise [ArgumentError] If users with passwords are provided but no hash_alg is specified.
        # @raise [Error] If the import operation fails.
        #
        # @return [UserImportResult] An object summarizing the result of the import operation.
        def import_users(users, hash_alg = nil)
          validate_users_array(users)
          validate_hash_alg_for_passwords(users, hash_alg)

          payload = {
            users: users.map(&:to_h)
          }

          if hash_alg
            payload[:hashConfig] = hash_alg.to_h
          end

          response = @client.post(with_path("accounts:batchCreate"), payload).body
          UserImportResult.from_api_response(response)
        end

        private

        def with_path(path)
          "projects/#{@project_id}/#{path}"
        end

        def validate_users_array(users)
          raise ArgumentError, "users must be an array" unless users.is_a?(Array)
          raise ArgumentError, "users array must not be empty" if users.empty?
          raise ArgumentError, "users array must not contain more than 1000 elements" if users.length > 1000
          
          users.each_with_index do |user, index|
            unless user.is_a?(ImportUserRecord)
              raise ArgumentError, "users array must contain only ImportUserRecord instances (found #{user.class} at index #{index})"
            end
          end
        end

        def validate_hash_alg_for_passwords(users, hash_alg)
          users_with_passwords = users.any? { |user| user.password_hash }
          
          if users_with_passwords && hash_alg.nil?
            raise ArgumentError, "hash_alg must be specified when importing users with passwords"
          end
          
          if hash_alg && !hash_alg.is_a?(UserImportHash)
            raise ArgumentError, "hash_alg must be a UserImportHash instance"
          end
        end

        include Utils
      end
    end
  end
end
