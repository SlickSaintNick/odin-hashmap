# frozen_string_literal: true

# A HashMap for String data type using singly-linked lists.
class HashMap
  attr_accessor :buckets

  def initialize(initial_capacity = 16)
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
    value
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

books = HashMap.new(4)
puts 'Books and authors - a HashMap...'
puts books
gets
puts "Put #{books.set('Leo Tolstoy', 'Anna Karenina')} and "\
     "#{books.set('Fyodor Dostoyevsky', 'Crime and Punishment')} "\
     'on the shelf...'
puts books
gets
puts "Put #{books.set('James Joyce', 'Ulysses')} on there... time for a bigger shelf..."
puts books
gets
puts "Put #{books.set('China Mieville', 'Perdido Street Station')} and "\
     "#{books.set('Haruki Murakami', 'Norwegian Wood')} "\
     'on there as well...'
puts books
puts "Now there are #{books.length} books."
puts "The book by Tolstoy is #{books.get('Leo Tolstoy')}. I'll swap it for "\
     "#{books.set('Leo Tolstoy', 'War and Peace')}."
puts books
gets
puts "The list of authors is: #{books.keys}."
puts "The list of titles is: #{books.values}."
puts 'Time to clear the shelf!'
books.clear
puts books
