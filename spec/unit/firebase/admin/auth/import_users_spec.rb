require_relative "../../../spec_helper"

describe Firebase::Admin::Auth do
  describe "ImportUserRecord" do
    it "creates a valid import user record" do
      user = Firebase::Admin::Auth::ImportUserRecord.new(
        uid: "test123",
        email: "test@example.com",
        display_name: "Test User"
      )
      
      expect(user.uid).to eq("test123")
      expect(user.email).to eq("test@example.com")
      expect(user.display_name).to eq("Test User")
    end

    it "validates uid requirements" do
      expect {
        Firebase::Admin::Auth::ImportUserRecord.new(uid: "")
      }.to raise_error(ArgumentError, "uid must be a non-empty string")
      
      expect {
        Firebase::Admin::Auth::ImportUserRecord.new(uid: "a" * 129)
      }.to raise_error(ArgumentError, "uid must not be longer than 128 characters")
    end

    it "converts to hash correctly" do
      user = Firebase::Admin::Auth::ImportUserRecord.new(
        uid: "test123",
        email: "test@example.com",
        email_verified: true,
        disabled: false
      )
      
      hash = user.to_h
      expect(hash[:localId]).to eq("test123")
      expect(hash[:email]).to eq("test@example.com")
      expect(hash[:emailVerified]).to be true
      expect(hash[:disabled]).to be false
    end
  end

  describe "UserProvider" do
    it "creates a valid user provider" do
      provider = Firebase::Admin::Auth::UserProvider.new(
        uid: "provider123",
        provider_id: "google.com",
        email: "user@gmail.com"
      )
      
      expect(provider.uid).to eq("provider123")
      expect(provider.provider_id).to eq("google.com")
      expect(provider.email).to eq("user@gmail.com")
    end

    it "converts to hash correctly" do
      provider = Firebase::Admin::Auth::UserProvider.new(
        uid: "provider123",
        provider_id: "google.com"
      )
      
      hash = provider.to_h
      expect(hash[:rawId]).to eq("provider123")
      expect(hash[:providerId]).to eq("google.com")
    end
  end

  describe "UserImportHash" do
    it "creates bcrypt hash" do
      hash = Firebase::Admin::Auth::UserImportHash.bcrypt
      expect(hash.name).to eq("BCRYPT")
      expect(hash.to_h[:hashAlgorithm]).to eq("BCRYPT")
    end

    it "creates hmac sha256 hash" do
      hash = Firebase::Admin::Auth::UserImportHash.hmac_sha256("secret_key")
      expect(hash.name).to eq("HMAC_SHA256")
      expect(hash.to_h[:signerKey]).to eq("secret_key")
    end

    it "creates scrypt hash" do
      hash = Firebase::Admin::Auth::UserImportHash.scrypt("key", "salt", 8, 14)
      expect(hash.name).to eq("SCRYPT")
      expect(hash.to_h[:signerKey]).to eq("key")
      expect(hash.to_h[:saltSeparator]).to eq("salt")
      expect(hash.to_h[:rounds]).to eq(8)
      expect(hash.to_h[:memoryCost]).to eq(14)
    end
  end

  describe "UserImportResult" do
    it "creates from api response" do
      response_data = {
        "successCount" => 5,
        "failureCount" => 2,
        "error" => [
          { "index" => 1, "message" => "Invalid email" },
          { "index" => 3, "message" => "UID already exists" }
        ]
      }
      
      result = Firebase::Admin::Auth::UserImportResult.from_api_response(response_data)
      
      expect(result.success_count).to eq(5)
      expect(result.failure_count).to eq(2)
      expect(result.errors.length).to eq(2)
      expect(result.errors[0].index).to eq(1)
      expect(result.errors[0].message).to eq("Invalid email")
    end
  end

  describe "ErrorInfo" do
    it "creates from api response" do
      error_data = { "index" => 1, "message" => "Invalid email" }
      error_info = Firebase::Admin::Auth::ErrorInfo.from_api_response(error_data)
      
      expect(error_info.index).to eq(1)
      expect(error_info.message).to eq("Invalid email")
    end
  end
end 