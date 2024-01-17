# frozen_string_literal: true

# A HashMap for strings data type using singly-linked lists.
class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(1)
    @loadfactor = 1
    @size = 0
  end

  def hash(key)
    sum = 0
    key.each_char do |char|
      sum += char.ord
      sum *= char.ord
    end
    sum % @buckets.length
  end

  def set(key, value)
    hash_key = hash(key)
    # Add a new LinkedList if there is none at that location.
    @buckets[hash_key] = LinkedList.new if @buckets[hash_key].nil?
    # Check if the key already exists.
    if @buckets[hash_key].contains?(key)
      @buckets[hash_key].update_value(key, value)
    else
      @buckets[hash_key].prepend(key, value)
    end
  end
end

# Singly Linked List and essential methods.
class LinkedList
  attr_reader :head, :cursor

  def initialize
    @head = nil
  end

  def prepend(key, value)
    @head = Node.new(key, value, @head)
    value
  end

  def contains?(key)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor.key == key
  end

  def update_value(key, value)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor.key == key ? cursor.value = value : nil
  end
end

# Node forms structure of singly LinkedList
class Node
  attr_accessor :key, :value, :next_node

  def initialize(key = nil, value = nil, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end
end

# test_list = LinkedList.new
# test_list.prepend("key1", "value1")
# test_list.prepend("key2", "value2")
# p test_list
# p test_list.contains?('key1')
# p test_list.update_value('key1', 'new_value')
# p test_list

test_hash = HashMap.new
p test_hash.buckets[0]
test_hash.set('key1', 'value1')
test_hash.set('key2', 'value2')
p test_hash.buckets[0]
test_hash.set('key1', 'new value1')
test_hash.set('key2', 'new value2')
p test_hash.buckets[0]
