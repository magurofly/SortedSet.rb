# SortedSet.rb version 1.1

SortedSet = Class.new do
  BUCKET_RATIO = 50
  REBUILD_RATIO = 170
  
  include Enumerable
  attr_reader :size, :a

  # Evenly divide `a` into buckets.
  def _build(a = nil)
    a ||= to_a
    size = @size = a.size
    bucket_size = Math.sqrt(size.to_f / BUCKET_RATIO).ceil
    @a = (0 ... bucket_size).map { |i| a[size * i / bucket_size ... size * (i + 1) / bucket_size] }
  end

  def empty?
    @size == 0
  end

  # Make a new SortedSet from Enumerable. / O(N) if sorted and unique / O(N log N)
  def initialize(a = [])
    a = a.to_a
    a = a.uniq.sort unless a.each_cons(2).all? { |x, y| x < y }
    _build(a)
  end

  def each(&block)
    unless block_given?
      return Enumerator.new do |y|
        each do |x|
          y << x
        end
      end
    end 
    @a.each do |i|
      i.each(&block)
    end
  end

  def reverse_each(&block)
    unless block_given?
      return Enumerator.new do |y|
        reverse_each do |x|
          y << x
        end
      end
    end 
    @a.reverse_each do |i|
      i.reverse_each(&block)
    end
  end

  def inspect
    "#{self.class.name}#{@a.inspect}"
  end

  def to_s
    "{#{@a.join(", ")}}"
  end

  # Find the bucket which should contain x. self must not be empty.
  def _find_bucket(x)
    @a.find { |a| x <= a[-1] } || @a[-1]
  end

  def include?(x)
    return false if @size == 0
    a = _find_bucket(x)
    i = a.bsearch_index { |y| y >= x }
    i and a[i] == x
  end

  # Add an element and return true if added. O(√N)
  def add(x)
    if @size == 0
      @a = [[x]]
      @size = 1
      return true
    end
    a = _find_bucket(x)
    i = a.bsearch_index { |y| y >= x } || a.size
    return false if i and a[i] == x
    a.insert(i, x)
    @size += 1
    _build if a.size > @a.size * REBUILD_RATIO
    true
  end

  def <<(x)
    self.add(x)
    self
  end

  # Remove and element and return true if removed. O(√N)
  def discard(x)
    return false if @size == 0
    a = _find_bucket(x)
    i = a.bsearch_index { |y| y >= x }
    return false unless i and a[i] == x
    a.delete_at(i)
    @size -= 1
    _build if a.empty?
    true
  end

  alias :delete :discard

  # Find the largest element < x, or nil if it doesn't exist.
  def lt(x)
    @a.reverse_each do |a|
      return a[(a.bsearch_index { |y| y >= x } || a.size) - 1] if a[0] < x
    end
    nil
  end

  # Find the largest element <= x, or nil if it doesn't exist.
  def le(x)
    @a.reverse_each do |a|
      return a[(a.bsearch_index { |y| y > x } || a.size) - 1] if a[0] <= x
    end
    nil
  end

  # Find the smallest element > x, or nil if it doesn't exist.
  def gt(x)
    @a.each do |a|
      return a.bsearch { |y| y > x } if a[-1] > x
    end
    nil
  end

  # Find the smallest element >= x, or nil if it doesn't exist.
  def ge(x)
    @a.each do |a|
      return a.bsearch { |y| y >= x } if a[-1] >= x
    end
    nil
  end

  # Return the x-th element, or nil if it doesn't exist.
  def [](x)
    x += @size if x < 0
    return nil if x < 0
    @a.each do |a|
      return a[x] if x < a.size
      x -= a.size
    end
    nil
  end

  # Count the number of elements < x
  def index(x)
    ans = 0
    @a.each do |a|
      return ans + a.bsearch_index { |y| y >= x } if a[-1] >= x
      ans += a.size
    end
    ans
  end

  # Count the number of elements <= x
  def index_right(x)
    ans = 0
    @a.each do |a|
      return ans + a.bsearch_index { |y| y > x } if a[-1] > x
      ans += a.size
    end
    ans
  end

  alias :rindex :index_right

  def to_a
    @a.flatten
  end
end

class SortedMultiset < SortedSet
  # Make a new SortedMultiset from Enumerable. / O(N) if sorted / O(N log N)
  def initialize(a = [])
    a = a.to_a
    a = a.uniq.sort unless a.each_cons(2).all? { |x, y| x <= y }
    _build(a)
  end

  # Count the number of x.
  def count(x)
    rindex(x) - index(x)
  end

  # Add an element. / O(√N)
  def add(x)
    if empty?
      @a = [[x]]
      @size = 1
      return
    end
    a = _find_bucket(x)
    i = a.bsearch_index { |y| y > x } || a.size
    a.insert(i, x)
    @size += 1
    _build if a.size > @a.size * REBUILD_RATIO
  end
end