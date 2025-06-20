#!/usr/bin/env ruby

# Example usage of the Firebase Admin SDK import_users functionality
# This example demonstrates how to bulk import users into Firebase Auth

require_relative "../lib/firebase-admin-sdk"

# Initialize Firebase Admin SDK
# You would typically load credentials from a service account file
# credentials = Firebase::Admin::Credentials.from_file("path/to/service-account.json")
# app = Firebase::Admin::App.new(credentials: credentials)

# For this example, we'll assume you have an initialized app
# app = Firebase::Admin::App.new(credentials: credentials)

puts "Firebase Admin SDK Import Users Example"
puts "======================================"

# Example 1: Import users without passwords
puts "\n1. Importing users without passwords:"

users_without_passwords = [
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "user1",
    email: "user1@example.com",
    display_name: "User One",
    email_verified: true
  ),
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "user2",
    email: "user2@example.com",
    display_name: "User Two",
    phone_number: "+1234567890"
  ),
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "user3",
    email: "user3@example.com",
    disabled: true
  )
]

# result = app.auth.import_users(users_without_passwords)
# puts "Successfully imported: #{result.success_count} users"
# puts "Failed to import: #{result.failure_count} users"
# result.errors.each do |error|
#   puts "Error at index #{error.index}: #{error.message}"
# end

# Example 2: Import users with password hashes
puts "\n2. Importing users with password hashes:"

# Create a hash configuration for bcrypt passwords
hash_config = Firebase::Admin::Auth::UserImportHash.bcrypt

users_with_passwords = [
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "hashed_user1",
    email: "hashed1@example.com",
    password_hash: "base64_encoded_bcrypt_hash_here",
    password_salt: "base64_encoded_salt_here"
  ),
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "hashed_user2",
    email: "hashed2@example.com",
    password_hash: "another_base64_encoded_hash"
  )
]

# result = app.auth.import_users(users_with_passwords, hash_config)
# puts "Successfully imported: #{result.success_count} users"
# puts "Failed to import: #{result.failure_count} users"

# Example 3: Import users with custom claims
puts "\n3. Importing users with custom claims:"

users_with_claims = [
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "admin_user",
    email: "admin@example.com",
    custom_claims: {
      admin: true,
      role: "administrator",
      permissions: ["read", "write", "delete"]
    }
  ),
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "premium_user",
    email: "premium@example.com",
    custom_claims: {
      premium: true,
      subscription_tier: "gold"
    }
  )
]

# result = app.auth.import_users(users_with_claims)
# puts "Successfully imported: #{result.success_count} users"

# Example 4: Import users with provider data
puts "\n4. Importing users with provider data:"

google_provider = Firebase::Admin::Auth::UserProvider.new(
  uid: "google_uid_123",
  provider_id: "google.com",
  email: "google_user@gmail.com",
  display_name: "Google User",
  photo_url: "https://example.com/photo.jpg"
)

users_with_providers = [
  Firebase::Admin::Auth::ImportUserRecord.new(
    uid: "linked_user",
    email: "linked@example.com",
    provider_data: [google_provider]
  )
]

# result = app.auth.import_users(users_with_providers)
# puts "Successfully imported: #{result.success_count} users"

# Example 5: Different hash algorithms
puts "\n5. Using different hash algorithms:"

# HMAC SHA256
hmac_sha256_config = Firebase::Admin::Auth::UserImportHash.hmac_sha256("your_secret_key")

# PBKDF2 SHA256
pbkdf2_config = Firebase::Admin::Auth::UserImportHash.pbkdf2_sha256(10000)

# SCRYPT
scrypt_config = Firebase::Admin::Auth::UserImportHash.scrypt("signer_key", "salt_separator", 8, 14)

puts "Available hash algorithms:"
puts "- BCRYPT: #{Firebase::Admin::Auth::UserImportHash.bcrypt.to_h}"
puts "- HMAC_SHA256: #{hmac_sha256_config.to_h}"
puts "- PBKDF2_SHA256: #{pbkdf2_config.to_h}"
puts "- SCRYPT: #{scrypt_config.to_h}"

puts "\nExample completed successfully!"
puts "Note: This example shows the API structure. In a real application,"
puts "you would need to provide actual Firebase credentials and call the methods." 