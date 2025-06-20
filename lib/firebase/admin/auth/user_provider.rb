module Firebase
  module Admin
    module Auth
      # Represents a user identity provider that can be associated with a Firebase user.
      #
      # One or more providers can be specified in an ImportUserRecord when importing users via
      # the UserManager#import_users method.
      class UserProvider
        # @return [String] User's unique ID assigned by the identity provider.
        attr_reader :uid

        # @return [String] ID of the identity provider. This can be a short domain name or the identifier
        #   of an OpenID identity provider.
        attr_reader :provider_id

        # @return [String, nil] User's email address (optional).
        attr_reader :email

        # @return [String, nil] User's display name (optional).
        attr_reader :display_name

        # @return [String, nil] User's photo URL (optional).
        attr_reader :photo_url

        # Initializes a new UserProvider.
        #
        # @param [String] uid User's unique ID assigned by the identity provider.
        # @param [String] provider_id ID of the identity provider. This can be a short domain name or the identifier
        #   of an OpenID identity provider.
        # @param [String, nil] email User's email address (optional).
        # @param [String, nil] display_name User's display name (optional).
        # @param [String, nil] photo_url User's photo URL (optional).
        #
        # @raise [ArgumentError] If provided arguments are invalid.
        def initialize(uid:, provider_id:, email: nil, display_name: nil, photo_url: nil)
          @uid = validate_uid(uid)
          @provider_id = validate_provider_id(provider_id)
          @email = validate_email(email)
          @display_name = validate_display_name(display_name)
          @photo_url = validate_photo_url(photo_url)
        end

        # Converts the UserProvider to a hash suitable for the Firebase API.
        #
        # @return [Hash] A hash representation of the user provider.
        def to_h
          {
            rawId: @uid,
            providerId: @provider_id,
            email: @email,
            displayName: @display_name,
            photoUrl: @photo_url
          }.compact
        end

        private

        def validate_uid(uid)
          raise ArgumentError, "uid must be a non-empty string" unless uid.is_a?(String) && !uid.empty?
          uid
        end

        def validate_provider_id(provider_id)
          raise ArgumentError, "provider_id must be a non-empty string" unless provider_id.is_a?(String) && !provider_id.empty?
          provider_id
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

        def validate_photo_url(photo_url)
          return nil if photo_url.nil?
          raise ArgumentError, "photo_url must be a string" unless photo_url.is_a?(String)
          raise ArgumentError, "photo_url must not be empty" if photo_url.empty?
          photo_url
        end
      end
    end
  end
end 