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
    # Double the number of buckets and rehash all the entries.
    current_entries = entries
    @buckets = Array.new(@buckets.length * 2)
    @size = 0
    current_entries.each { |entry| set(entry[0], entry[1]) }
  end

  def set(key, value)
    hash_key = hash(key)
    # Add a new LinkedList if there is none at that location.
    @buckets[hash_key] = LinkedList.new if @buckets[hash_key].nil?
    # Check if the key already exists. If it does, update it. If it doesn't, add it and increase size.
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

    value = @buckets[hash_key].remove_key(key)
    @size -= 1 unless value.nil?
    value
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

  def entries
    entries = []
    @buckets.each { |bucket| entries += bucket.to_a unless bucket.nil? }
    entries
  end

  def keys
    entries.map { |entry| entry[0] }
  end

  def values
    entries.map { |entry| entry[1] }
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

  def cursor_to_key(key)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor
  end

  def contains?(key)
    cursor_to_key(key).key == key
  end

  def update_value(key, value)
    cursor = cursor_to_key(key)
    cursor.key == key ? cursor.value = value : nil
  end

  def value_from_key(key)
    cursor = cursor_to_key(key)
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
    cursor.key == key ? remove_node(prev, cursor) : nil
  end

  def remove_head
    temp = @head.value
    @head = @head.next_node
    temp
  end

  def remove_node(prev, cursor)
    temp = cursor.value
    prev.next_node = cursor.next_node
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

# Node (key, value) forms structure of singly LinkedList
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
