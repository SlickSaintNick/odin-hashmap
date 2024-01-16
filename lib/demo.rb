# frozen_string_literal: true

require './hashmap'
require 'faker'

p user_hash = HashMap.new
user_hash.set('fake_user', 'fake_email@fake.com')
puts user_hash.buckets
user_hash.set('foobarboobash', 'fake_email@fake.com2')
puts user_hash.buckets
user_hash.set('fake_user', 'new_fake_email@fake.com')
puts user_hash.buckets
puts user_hash.get('fake_user')
puts user_hash.key?('fake_user')
puts user_hash.key?('fake_user_not_here')
puts user_hash.remove('foobarboobash')
puts user_hash.buckets
puts '-----------------------'
my_hash = []
my_hash[0] = LinkedList.new
my_hash[0].prepend('fake_user', 'fake_email@fake.com')
my_hash[0].prepend('fake_user2', 'fake_email@fake.com2')
puts my_hash[0]
my_hash[0].remove('fake_user')
puts my_hash[0]



# A class used for testing purposes to create random name strings.
class FakeLogin
  attr_accessor :username, :email

  def initialize(info)
    @username = info[:username]
    @email = info[:email]
  end
end

fuzzer = ->(k) { Faker::Internet.send(k) }

# 5.times do
#   temp = FakeLogin.new(fuzzer)
#   user_hash.set(temp.username, temp.email)
# end
