require "json"

module Firebase
  module Admin
    module Auth
      # Represents a user account to be imported to Firebase Auth.
      #
      # Must specify the uid field at a minimum. A sequence of ImportUserRecord objects can be
      # passed to the UserManager#import_users method, in order to import those users into Firebase
      # Auth in bulk. If the password_hash is set on a user, a hash configuration must be
      # specified when calling import_users.
      class ImportUserRecord
        # @return [String] User's unique ID. Must be a non-empty string not longer than 128 characters.
        attr_reader :uid

        # @return [String, nil] User's email address (optional).
        attr_reader :email

        # @return [Boolean, nil] A boolean indicating whether the user's email has been verified (optional).
        attr_reader :email_verified

        # @return [String, nil] User's display name (optional).
        attr_reader :display_name

        # @return [String, nil] User's phone number (optional).
        attr_reader :phone_number

        # @return [String, nil] User's photo URL (optional).
        attr_reader :photo_url

        # @return [Boolean, nil] A boolean indicating whether this user account has been disabled (optional).
        attr_reader :disabled

        # @return [Hash, nil] A hash of custom claims to be set on the user account (optional).
        attr_reader :custom_claims

        # @return [String, nil] User's password hash as a base64-encoded string (optional).
        attr_reader :password_hash

        # @return [String, nil] User's password salt as a base64-encoded string (optional).
        attr_reader :password_salt

        # @return [Array<UserProvider>, nil] A list of UserProvider instances (optional).
        attr_reader :provider_data

        # Initializes a new ImportUserRecord.
        #
        # @param [String] uid User's unique ID. Must be a non-empty string not longer than 128 characters.
        # @param [String, nil] email User's email address (optional).
        # @param [Boolean, nil] email_verified A boolean indicating whether the user's email has been verified (optional).
        # @param [String, nil] display_name User's display name (optional).
        # @param [String, nil] phone_number User's phone number (optional).
        # @param [String, nil] photo_url User's photo URL (optional).
        # @param [Boolean, nil] disabled A boolean indicating whether this user account has been disabled (optional).
        # @param [Hash, nil] custom_claims A hash of custom claims to be set on the user account (optional).
        # @param [String, nil] password_hash User's password hash as a base64-encoded string (optional).
        # @param [String, nil] password_salt User's password salt as a base64-encoded string (optional).
        # @param [Array<UserProvider>, nil] provider_data A list of UserProvider instances (optional).
        #
        # @raise [ArgumentError] If provided arguments are invalid.
        def initialize(uid:, email: nil, email_verified: nil, display_name: nil, phone_number: nil, 
                      photo_url: nil, disabled: nil, custom_claims: nil, password_hash: nil, 
                      password_salt: nil, provider_data: nil)
          @uid = validate_uid(uid)
          @email = validate_email(email)
          @email_verified = email_verified
          @display_name = validate_display_name(display_name)
          @phone_number = validate_phone_number(phone_number)
          @photo_url = validate_photo_url(photo_url)
          @disabled = disabled
          @custom_claims = validate_custom_claims(custom_claims)
          @password_hash = validate_password_hash(password_hash)
          @password_salt = validate_password_salt(password_salt)
          @provider_data = validate_provider_data(provider_data)
        end

        # Converts the ImportUserRecord to a hash suitable for the Firebase API.
        #
        # @return [Hash] A hash representation of the user record.
        def to_h
          {
            localId: @uid,
            email: @email,
            emailVerified: @email_verified,
            displayName: @display_name,
            phoneNumber: @phone_number,
            photoUrl: @photo_url,
            disabled: @disabled,
            customAttributes: @custom_claims&.to_json,
            passwordHash: @password_hash,
            salt: @password_salt,
            providerUserInfo: @provider_data&.map(&:to_h)
          }.compact
        end

        private

        def validate_uid(uid)
          raise ArgumentError, "uid must be a non-empty string" unless uid.is_a?(String) && !uid.empty?
          raise ArgumentError, "uid must not be longer than 128 characters" unless uid.length <= 128
          uid
        end

        def validate_email(email)
          return nil if email.nil?
          raise ArgumentError, "email must be a string" unless email.is_a?(String)
          raise ArgumentError, "email must not be empty" if email.empty?
          email
        end

        def validate_display_name(display_name)
          return nil if display_name.nil?
          raise ArgumentError, "display_name must be a string" unless display_name.is_a?(String)
          display_name
        end

        def validate_phone_number(phone_number)
          return nil if phone_number.nil?
          raise ArgumentError, "phone_number must be a string" unless phone_number.is_a?(String)
          raise ArgumentError, "phone_number must be an E.164 identifier" unless phone_number.match?(/^\+\d{1,14}$/)
          phone_number
        end

        def validate_photo_url(photo_url)
          return nil if photo_url.nil?
          raise ArgumentError, "photo_url must be a string" unless photo_url.is_a?(String)
          raise ArgumentError, "photo_url must not be empty" if photo_url.empty?
          photo_url
        end

        def validate_custom_claims(custom_claims)
          return nil if custom_claims.nil?
          raise ArgumentError, "custom_claims must be a hash" unless custom_claims.is_a?(Hash)
          custom_claims
        end

        def validate_password_hash(password_hash)
          return nil if password_hash.nil?
          raise ArgumentError, "password_hash must be a string" unless password_hash.is_a?(String)
          raise ArgumentError, "password_hash must not be empty" if password_hash.empty?
          password_hash
        end

        def validate_password_salt(password_salt)
          return nil if password_salt.nil?
          raise ArgumentError, "password_salt must be a string" unless password_salt.is_a?(String)
          raise ArgumentError, "password_salt must not be empty" if password_salt.empty?
          password_salt
        end

        def validate_provider_data(provider_data)
          return nil if provider_data.nil?
          raise ArgumentError, "provider_data must be an array" unless provider_data.is_a?(Array)
          provider_data.each do |provider|
            raise ArgumentError, "provider_data must contain only UserProvider instances" unless provider.is_a?(UserProvider)
          end
          provider_data
        end
      end
    end
  end
end 