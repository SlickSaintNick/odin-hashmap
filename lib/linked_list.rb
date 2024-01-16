# frozen_string_literal: true

# Class to create and manage linked lists.
class LinkedList
  attr_reader :head

  def initialize
    @head = nil
  end

  # Adds a new node to the start of the list
  def prepend(key, value)
    @head = Node.new(key, value, @head)
    value
  end

  # Adds a new node to the end of the list
  def append(key, value)
    if @head.nil?
      prepend(key, value)
    else
      tail.next_node = Node.new(key, value, nil)
    end
    value
  end

  # Returns the total number of nodes in the list
  def size
    size = 0
    cursor = Node.new(nil, nil, @head)

    until cursor.next_node.nil?
      cursor = cursor.next_node
      size += 1
    end
    size
  end

  # tail returns the last node in the list
  def tail
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.next_node.nil?
    cursor
  end

  # at(index) returns the node at the given index
  # def at(index)
  #   counter = -1
  #   cursor = Node.new(nil, nil, @head)

  #   until counter == index || cursor.next_node.nil?
  #     counter += 1
  #     cursor = cursor.next_node
  #   end

  #   counter == index ? cursor : nil
  # end

  # Removes the last element from the list, and returns its value
  # def pop
  #   temp = at(size - 1)
  #   at(size - 2).next_node = nil
  #   temp.value
  # end

  # contains_value?(value) returns true if the passed in value is in the list and otherwise returns false.
  def contains_value?(value)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.value == value || cursor.next_node.nil?
    cursor.value == value
  end

  # contains_key?(key) returns true if the passed in key is in the list and otherwise returns false.
  def contains_key?(key)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor.key == key
  end

  def update_value(key, value)
    cursor = Node.new(nil, nil, @head)
    cursor = cursor.next_node until cursor.key == key || cursor.next_node.nil?
    cursor.key == key ? cursor.value = value : nil
  end
  # find_value(value) returns the index of the node containing value, or nil if not found.
  # def find(value)
  #   counter = -1
  #   cursor = Node.new(nil, nil, @head)

  #   until cursor.value == value || cursor.next_node.nil?
  #     cursor = cursor.next_node
  #     counter += 1
  #   end

  #   cursor.value == value ? counter : nil
  # end

  # find_key(key) returns the index of the node containing key, or nil if not found.
  def find(key)
    counter = -1
    cursor = Node.new(nil, nil, @head)

    until cursor.key == key || cursor.next_node.nil?
      cursor = cursor.next_node
      counter += 1
    end

    cursor.key == key ? counter : nil
  end

  def value_from_key(key)
    cursor = Node.new(nil, nil, @head)

    until cursor.key == key || cursor.next_node.nil?
      cursor = cursor.next_node
    end

    cursor.key == key ? cursor.value : nil
  end

  # to_s represents LinkedList objects as strings, to preview in console.
  # Format e.g.: ( key: value ) -> ( key: value ) ->nil
  def to_s
    string = ''
    cursor = Node.new(nil, nil, @head)

    until cursor.next_node.nil?
      cursor = cursor.next_node
      string += "( #{cursor.key}: #{cursor.value} ) -> "
    end

    "#{string}nil"
  end

  # insert_at(key, value, index) inserts a new node with the provided value at the given index.
  # def insert_at(key, value, index)
  #   return nil if at(index - 1).nil?

  #   temp = at(index - 1)
  #   at(index - 1).next_node = Node.new(key, value, temp.next_node)
  #   value
  # end

  # Removes the node with the given key.
  def remove(key)
    return nil if @head.nil?

    prev = Node.new(nil, nil, @head)
    cursor = Node.new(nil, nil, @head.next_node)

    until cursor.key == key || cursor.next_node.nil?
      cursor = cursor.next_node
      prev = prev.next_node
    end

    return nil unless cursor.key == key

    prev.next_node = cursor.next_node
    cursor.value
  end
end

# Node to hold data within the LinkedList class.
class Node
  attr_accessor :key, :value, :next_node

  def initialize(key = nil, value = nil, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end
end
