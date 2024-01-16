# frozen_string_literal: true

require './linked_list'

# Some planning:
# Initialize a HashMap of a certain size - empty array of that size.
# Copy the hash that we worked out from the previous bit.

# set: hash the value and add it to the array index.
#   If that index is empty, new linked list.
#   Else, add to end of linked list.
#   Check if the @size / @buckets.length is above @loadfactor. If it is, double the size and rehash the values.

# A HashMap for strings data type using linked lists and dynamic rehashing.
class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(1)
    @loadfactor = 1
    @size = 0
  end

  def string_to_number(string)
    hash_code = 0
    string.each_char { |char| hash_code = 31 * hash_code + char.ord }
    hash_code
  end

  # Produce a hash code with the value.
  def hash(value)
    value.is_a?(String) ? string_to_number(value) % @buckets.length : nil
  end

  def set(key, value)
    hash_key = hash(key)
    # Create a new Linked List if there is none at the location.
    @buckets[hash_key] = LinkedList.new if @buckets[hash_key].nil?
    # Update the key and return, if it already exists.
    return unless @buckets[hash_key].update_value(key, value).nil?

    # Otherwise, add the new item to the beginning of the list and increase the size.
    @buckets[hash_key].prepend(key, value)
    @size += 1

    # rehash if @size / @buckets.length > @loadfactor
  end

  def rehash
    # duplicate the current array.
    # create a new array blank array in @buckets, double the size of the current array.
    # rehash all values. I.e. iterate through the temp array, and hash every key to the new array.
    # return true.
  end

  # Return value assigned to key, or nil if not found.
  def get(key)
    @buckets[hash(key)].value_from_key(key)
    # bucket.find_key(key).value
  end

  def key?(key)
    return false if @buckets[hash(key)].nil?

    @buckets[hash(key)].contains_key?(key)
  end

  # Remove and return value. Nil if not found.
  def remove(key)
    return nil if @buckets[hash(key)].nil?

    @buckets[hash(key)].remove(key)
  end

  # Returns number of keys in hash map
  def length
    key_count = 0
    @buckets.each { |bucket| key_count += bucket.size unless bucket.nil?}
  end

  def clear
    # Removes all entries in the hash map
  end

  def keys
    # Returns an array with all the keys in the hash map
  end

  def entries
    # Returns an array with each key, value pair. E.g.
    # [[key1, value1], [key2, value2]]
  end
end

class HashSet
  # Same as a HashMap but only keys, no values.
end

# raise IndexError if index.negative? || index >= @buckets.length
