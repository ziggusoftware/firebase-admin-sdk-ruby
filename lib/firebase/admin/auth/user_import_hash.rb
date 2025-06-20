module Firebase
  module Admin
    module Auth
      # Represents a hash algorithm used to hash user passwords.
      #
      # An instance of this class must be specified when importing users with passwords via the
      # UserManager#import_users method. Use one of the provided class methods to obtain new
      # instances when required.
      class UserImportHash
        # @return [String] The name of the hash algorithm.
        attr_reader :name

        # @return [Hash, nil] Additional data required for the hash algorithm (optional).
        attr_reader :data

        # Initializes a new UserImportHash.
        #
        # @param [String] name The name of the hash algorithm.
        # @param [Hash, nil] data Additional data required for the hash algorithm (optional).
        def initialize(name:, data: nil)
          @name = name
          @data = data
        end

        # Converts the UserImportHash to a hash suitable for the Firebase API.
        #
        # @return [Hash] A hash representation of the hash configuration.
        def to_h
          {
            hashAlgorithm: @name,
            **(@data || {})
          }
        end

        # Creates a new Bcrypt algorithm instance.
        #
        # @return [UserImportHash] A new UserImportHash instance for Bcrypt.
        def self.bcrypt
          new(name: "BCRYPT")
        end

        # Creates a new HMAC MD5 algorithm instance.
        #
        # @param [String] key The HMAC key.
        # @return [UserImportHash] A new UserImportHash instance for HMAC MD5.
        def self.hmac_md5(key)
          new(name: "HMAC_MD5", data: { signerKey: key })
        end

        # Creates a new HMAC SHA1 algorithm instance.
        #
        # @param [String] key The HMAC key.
        # @return [UserImportHash] A new UserImportHash instance for HMAC SHA1.
        def self.hmac_sha1(key)
          new(name: "HMAC_SHA1", data: { signerKey: key })
        end

        # Creates a new HMAC SHA256 algorithm instance.
        #
        # @param [String] key The HMAC key.
        # @return [UserImportHash] A new UserImportHash instance for HMAC SHA256.
        def self.hmac_sha256(key)
          new(name: "HMAC_SHA256", data: { signerKey: key })
        end

        # Creates a new HMAC SHA512 algorithm instance.
        #
        # @param [String] key The HMAC key.
        # @return [UserImportHash] A new UserImportHash instance for HMAC SHA512.
        def self.hmac_sha512(key)
          new(name: "HMAC_SHA512", data: { signerKey: key })
        end

        # Creates a new MD5 algorithm instance.
        #
        # @return [UserImportHash] A new UserImportHash instance for MD5.
        def self.md5
          new(name: "MD5")
        end

        # Creates a new PBKDF2 SHA1 algorithm instance.
        #
        # @param [Integer] rounds The number of rounds.
        # @return [UserImportHash] A new UserImportHash instance for PBKDF2 SHA1.
        def self.pbkdf2_sha1(rounds)
          new(name: "PBKDF2_SHA1", data: { rounds: rounds })
        end

        # Creates a new PBKDF2 SHA256 algorithm instance.
        #
        # @param [Integer] rounds The number of rounds.
        # @return [UserImportHash] A new UserImportHash instance for PBKDF2 SHA256.
        def self.pbkdf2_sha256(rounds)
          new(name: "PBKDF2_SHA256", data: { rounds: rounds })
        end

        # Creates a new SCRYPT algorithm instance.
        #
        # @param [String] key The scrypt key.
        # @param [Integer] salt_separator The salt separator.
        # @param [Integer] rounds The number of rounds.
        # @param [Integer] memory_cost The memory cost.
        # @return [UserImportHash] A new UserImportHash instance for SCRYPT.
        def self.scrypt(key, salt_separator, rounds, memory_cost)
          new(name: "SCRYPT", data: {
            signerKey: key,
            saltSeparator: salt_separator,
            rounds: rounds,
            memoryCost: memory_cost
          })
        end

        # Creates a new SHA1 algorithm instance.
        #
        # @return [UserImportHash] A new UserImportHash instance for SHA1.
        def self.sha1
          new(name: "SHA1")
        end

        # Creates a new SHA256 algorithm instance.
        #
        # @return [UserImportHash] A new UserImportHash instance for SHA256.
        def self.sha256
          new(name: "SHA256")
        end

        # Creates a new SHA512 algorithm instance.
        #
        # @return [UserImportHash] A new UserImportHash instance for SHA512.
        def self.sha512
          new(name: "SHA512")
        end

        # Creates a new STANDARD SCRYPT algorithm instance.
        #
        # @param [Integer] memory_cost The memory cost.
        # @param [Integer] rounds The number of rounds.
        # @param [Integer] parallelization The parallelization factor.
        # @param [Integer] block_size The block size.
        # @param [Integer] dk_len The derived key length.
        # @return [UserImportHash] A new UserImportHash instance for STANDARD SCRYPT.
        def self.standard_scrypt(memory_cost, rounds, parallelization, block_size, dk_len)
          new(name: "STANDARD_SCRYPT", data: {
            memoryCost: memory_cost,
            rounds: rounds,
            parallelization: parallelization,
            blockSize: block_size,
            dkLen: dk_len
          })
        end
      end
    end
  end
end 