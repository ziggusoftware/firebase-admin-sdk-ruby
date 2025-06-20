#!/usr/bin/env ruby

# Simple example demonstrating the import_users functionality classes
# This example shows the structure without requiring Firebase credentials

# Load only the auth classes we need
require_relative "../lib/firebase/admin/auth/import_user_record"
require_relative "../lib/firebase/admin/auth/user_provider"
require_relative "../lib/firebase/admin/auth/user_import_hash"
require_relative "../lib/firebase/admin/auth/error_info"
require_relative "../lib/firebase/admin/auth/user_import_result"

puts "Firebase Admin SDK Import Users - Simple Example"
puts "==============================================="

# Example 1: Create ImportUserRecord instances
puts "\n1. Creating ImportUserRecord instances:"

user1 = Firebase::Admin::Auth::ImportUserRecord.new(
  uid: "user1",
  email: "user1@example.com",
  display_name: "User One",
  email_verified: true
)

user2 = Firebase::Admin::Auth::ImportUserRecord.new(
  uid: "user2",
  email: "user2@example.com",
  phone_number: "+1234567890",
  disabled: false
)

puts "Created user1: #{user1.uid} (#{user1.email})"
puts "Created user2: #{user2.uid} (#{user2.email})"

# Example 2: Create UserProvider instances
puts "\n2. Creating UserProvider instances:"

google_provider = Firebase::Admin::Auth::UserProvider.new(
  uid: "google_uid_123",
  provider_id: "google.com",
  email: "google_user@gmail.com",
  display_name: "Google User"
)

puts "Created Google provider: #{google_provider.provider_id} (#{google_provider.uid})"

# Example 3: Create UserImportHash instances
puts "\n3. Creating UserImportHash instances:"

bcrypt_hash = Firebase::Admin::Auth::UserImportHash.bcrypt
hmac_sha256_hash = Firebase::Admin::Auth::UserImportHash.hmac_sha256("secret_key")
pbkdf2_hash = Firebase::Admin::Auth::UserImportHash.pbkdf2_sha256(10000)

puts "BCRYPT hash config: #{bcrypt_hash.to_h}"
puts "HMAC_SHA256 hash config: #{hmac_sha256_hash.to_h}"
puts "PBKDF2_SHA256 hash config: #{pbkdf2_hash.to_h}"

# Example 4: Create users with different attributes
puts "\n4. Creating users with different attributes:"

user_with_password = Firebase::Admin::Auth::ImportUserRecord.new(
  uid: "hashed_user",
  email: "hashed@example.com",
  password_hash: "base64_encoded_hash_here",
  password_salt: "base64_encoded_salt_here"
)

user_with_claims = Firebase::Admin::Auth::ImportUserRecord.new(
  uid: "admin_user",
  email: "admin@example.com",
  custom_claims: {
    admin: true,
    role: "administrator"
  }
)

user_with_provider = Firebase::Admin::Auth::ImportUserRecord.new(
  uid: "linked_user",
  email: "linked@example.com",
  provider_data: [google_provider]
)

puts "User with password: #{user_with_password.uid}"
puts "User with claims: #{user_with_claims.uid}"
puts "User with provider: #{user_with_provider.uid}"

# Example 5: Simulate API response and create UserImportResult
puts "\n5. Simulating import result:"

# Simulate a successful API response
api_response = {
  "successCount" => 3,
  "failureCount" => 1,
  "error" => [
    { "index" => 2, "message" => "Email already exists" }
  ]
}

result = Firebase::Admin::Auth::UserImportResult.from_api_response(api_response)

puts "Import completed:"
puts "- Successfully imported: #{result.success_count} users"
puts "- Failed to import: #{result.failure_count} users"
puts "- Errors: #{result.errors.length}"

result.errors.each do |error|
  puts "  - Index #{error.index}: #{error.message}"
end

# Example 6: Show the hash representations
puts "\n6. Hash representations for API calls:"

puts "User1 hash: #{user1.to_h}"
puts "User with claims hash: #{user_with_claims.to_h}"
puts "Google provider hash: #{google_provider.to_h}"

puts "\nExample completed successfully!"
puts "These classes can be used with the Firebase Admin SDK to bulk import users." 