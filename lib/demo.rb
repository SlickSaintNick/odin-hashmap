# frozen_string_literal: true

require './hashmap'
require 'faker'

# A class used for testing purposes to create random name strings.
class FakePerson
  attr_accessor :name, :surname

  def initialize(info)
    @name = info[:first_name]
    @surname = info[:last_name]
  end
end

fuzzer = ->(k) { Faker::Name.send(k) }

# 10.times do
#   temp = FakePerson.new(fuzzer)
#   # Add FakePerson name to hash table
# end

names = HashMap.new
