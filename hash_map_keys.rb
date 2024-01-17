# frozen_string_literal: true

# A HashMap for String data type using singly-linked lists, keys only
class HashMapKeys
  attr_accessor :buckets

  def initialize(initial_capacity = 16, loadfactor = 0.75)
    @buckets = Array.new(initial_capacity)
    @loadfactor = loadfactor
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
    current_keys = keys
    @buckets = Array.new(@buckets.length * 2)
    @size = 0
    current_keys.each { |key| set(key) }
  end

  def set(key)
    hash_key = hash(key)
    # Add a new LinkedList if there is none at that location.
    @buckets[hash_key] = LinkedList.new if @buckets[hash_key].nil?
    # Check if the key already exists. If it does, return. If it doesn't, add it and increase size.
    return nil if @buckets[hash_key].contains?(key)

    @buckets[hash_key].prepend(key)
    @size += 1
    rehash if @size.to_f / @buckets.length >= @loadfactor
    key
  end

  # def get(key)
  #   hash_key = hash(key)
  #   return nil if @buckets[hash_key].nil?

  #   @buckets[hash_key].value_from_key(key)
  # end

  def remove(key)
    hash_key = hash(key)
    return nil if @buckets[hash_key].nil?

    result = @buckets[hash_key].remove_key(key)
    @size -= 1 unless result.nil?
    result
  end

  def key?(key)
    hash_key = hash(key)
    return false if @buckets[hash_key].nil?

    @buckets[hash_key].contains?(key)
  end

  def length
    keys.length
  end

  def clear
    @buckets = Array.new(@buckets.size)
    @size = 0
  end

  def keys
    keys = []
    @buckets.each { |bucket| keys += bucket.to_a unless bucket.to_a.nil? }
    keys
  end

  def to_s
    string = "-----\n"
    @buckets.each_with_index do |bucket, index|
      string += "#{index} -> "
      string += bucket.nil? ? 'nil' : bucket.to_s
      string += "\n"
    end
    string += "-----\n"
  end
end

# Singly Linked List and methods to support HashMap class.
class LinkedList
  attr_reader :head

  def initialize
    @head = nil
  end

  def prepend(key)
    @head = Node.new(key, @head)
    key
  end

  def cursor_to_key(key)
    cursor = Node.new(nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor
  end

  def contains?(key)
    cursor_to_key(key).key == key
  end

  def remove_key(key)
    return nil if @head.nil?

    return remove_head if @head.key == key

    prev = Node.new(nil, @head)
    cursor = Node.new(nil, @head.next_node)
    until cursor.key == key || cursor.next_node.nil?
      cursor = cursor.next_node
      prev = prev.next_node
    end
    cursor.key == key ? remove_node(prev, cursor) : nil
  end

  def remove_head
    temp = @head.key
    @head = @head.next_node
    temp
  end

  def remove_node(prev, cursor)
    temp = cursor.key
    prev.next_node = cursor.next_node
    temp
  end

  def size
    size = 0
    cursor = Node.new(nil, @head)
    until cursor.next_node.nil?
      cursor = cursor.next_node
      size += 1
    end
    size
  end

  def to_s
    string = ''
    cursor = Node.new(nil, @head)
    until cursor.next_node.nil?
      cursor = cursor.next_node
      string += "( #{cursor.key} ) -> "
    end
    "#{string}nil"
  end

  def to_a
    return nil if @head.nil?

    array = []
    cursor = Node.new(nil, @head)
    until cursor.next_node.nil?
      cursor = cursor.next_node
      array.push(cursor.key)
    end
    array
  end
end

# Node (key) forms structure of singly LinkedList
class Node
  attr_accessor :key, :next_node

  def initialize(key = nil, next_node = nil)
    @key = key
    @next_node = next_node
  end
end

books = HashMapKeys.new(4)
puts 'Books and authors - a HashMap...'
puts books
gets
puts "Put #{books.set('Anna Karenina')} and #{books.set('Crime and Punishment')} "\
     'on the shelf...'
puts books
gets
puts "Put #{books.set('Ulysses')} on there... time for a bigger shelf..."
puts books
gets
puts "Put #{books.set('Perdido Street Station')} and #{books.set('Norwegian Wood')} "\
     'on there as well...'
puts books
puts "Now there are #{books.length} books."
puts "Lets take #{books.remove('Anna Karenina')} off the shelf..."
puts books
gets
puts "The list of books is: #{books.keys}."
puts 'Time to clear the shelf!'
books.clear
puts books
