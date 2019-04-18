class PriorityQueue
  def initialize es = [], &block
    block = proc { |a, b| a < b } unless block_given?
    @fun = block
    @tree = []
    @n = 0

    es.each do |e| enqueue e end
  end

  def enqueue e
    @tree[@n] = e
    i = @n
    @n += 1
    until i.zero?
      j = (i-1)/2
      if @fun.(@tree[i], @tree[j])
        @tree[i], @tree[j] = @tree[j], @tree[i]
        i = j
      else
        break
      end
    end
    self
  end

  alias push enqueue
  alias << enqueue
  alias insert enqueue

  def dequeue
    return nil if @n.zero?
    @n -= 1
    @tree.first.tap do
      @tree[0] = @tree[@n]
      @tree = @tree[0..-2]
      i = 0
      loop do
        l = i*2+1
        r = i*2+2
        break if @tree[l].nil?
        j =
          if @tree[r].nil?
            l
          else
            @fun.(@tree[r], @tree[l]) ? r : l
          end
        if @fun.(@tree[j], @tree[i])
          @tree[i], @tree[j] = @tree[j], @tree[i]
          i = j
        else
          break
        end
      end
    end
  end

  alias pop dequeue
  alias remove dequeue

  def peek
    @tree.first
  end

  alias first peek
  alias top peek

  def to_a
    [].tap do |arr|
      while e = dequeue
        arr << e
      end
    end
  end
end