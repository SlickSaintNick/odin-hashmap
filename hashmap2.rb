# frozen_string_literal: true

# A HashMap for String data type using singly-linked lists.
class HashMap
  attr_accessor :buckets

  def initialize(initial_capacity)
    @buckets = Array.new(initial_capacity)
    @loadfactor = 0.75
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

  def rehash
    current_entries = entries
    @buckets = Array.new(@buckets.length * 2)
    @size = 0
    current_entries.each { |entry| set(entry[0], entry[1]) }
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
      @size += 1
      rehash if @size.to_f / @buckets.length >= @loadfactor
    end
  end

  def get(key)
    hash_key = hash(key)
    return nil if @buckets[hash_key].nil?

    @buckets[hash_key].value_from_key(key)
  end

  def remove(key)
    hash_key = hash(key)
    return nil if @buckets[hash_key].nil?

    @size -= 1
    @buckets[hash_key].remove_key(key)
  end

  def key?(key)
    hash_key = hash(key)
    return false if @buckets[hash_key].nil?

    @buckets[hash_key].contains?(key)
  end

  def length
    entries.length
  end

  def clear
    @buckets = Array.new(@buckets.size)
    @size = 0
  end

  def keys
    keys = []
    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.to_a.each { |element| keys.push(element[0]) }
    end
    keys
  end

  def values
    values = []
    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.to_a.each { |element| values.push(element[1]) }
    end
    values
  end

  def entries
    entries = []
    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.to_a.each { |element| entries.push(element) }
    end
    entries
  end

  def to_s
    @buckets.each_with_index do |bucket, index|
      print "#{index} -> "
      print bucket.nil? ? 'nil' : bucket.to_s
      print "\n"
    end
    puts 'END'
  end
end

# Singly Linked List and methods to support HashMap class.
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

  def value_from_key(key)
    cursor = Node.new(nil, nil, @head)

    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor.key == key ? cursor.value : nil
  end

  def remove_key(key)
    return nil if @head.nil?

    return remove_head if @head.key == key

    prev = Node.new(nil, nil, @head)
    cursor = Node.new(nil, nil, @head.next_node)
    until cursor.key == key || cursor.next_node.nil?
      cursor = cursor.next_node
      prev = prev.next_node
    end

    if cursor.key == key
      temp = cursor.value
      prev.next_node = cursor.next_node
      temp
    else
      nil
    end
  end

  def remove_head
    temp = @head.value
    @head = @head.next_node
    temp
  end

  def size
    size = 0
    cursor = Node.new(nil, nil, @head)

    until cursor.next_node.nil?
      cursor = cursor.next_node
      size += 1
    end
    size
  end

  def to_s
    string = ''
    cursor = Node.new(nil, nil, @head)

    until cursor.next_node.nil?
      cursor = cursor.next_node
      string += "( #{cursor.key}: #{cursor.value} ) -> "
    end

    "#{string}nil"
  end

  def to_a
    return nil if @head.nil?

    array = []
    cursor = Node.new(nil, nil, @head)
    until cursor.next_node.nil?
      cursor = cursor.next_node
      array.push([cursor.key, cursor.value])
    end
    array
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
# p test_list.to_a
# test_list.prepend("key1", "value1")
# p test_list.to_a
# test_list.prepend("key2", "value2")
# puts test_list
# p test_list.contains?('key1')
# p test_list.update_value('key1', 'new_value')
# puts test_list
# p test_list.to_a
# p test_list.value_from_key('key1')
# p test_list.value_from_key('key2')
# p test_list.value_from_key('key3')
# puts test_list
# puts test_list.size
# p test_list.remove_key('key1')
# p test_list.remove_key('key2')
# p test_list.remove_key('key2')
# puts test_list
# puts test_list.size

test_hash = HashMap.new(4)
puts test_hash
test_hash.set('key1', 'value1')
test_hash.set('key2', 'value2')
puts test_hash
test_hash.set('key1', 'new value1')
test_hash.set('key2', 'new value2')
puts test_hash
test_hash.set('key3', 'value3')
test_hash.set('key4', 'value4')
test_hash.set('key5', 'value5')
test_hash.set('key6', 'value6')
puts test_hash
puts test_hash.length
puts test_hash.get('key2')
puts test_hash.get('key5')
p test_hash.get('key10')
p test_hash.key?('key2')
p test_hash.key?('foo')
puts test_hash.remove('key3')
puts test_hash.remove('key5')
puts test_hash
puts test_hash.length
p test_hash.keys
p test_hash.values
p test_hash.entries
test_hash.clear
puts test_hash
