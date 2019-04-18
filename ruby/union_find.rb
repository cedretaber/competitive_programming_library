class UFTree
  class Node
    attr_accessor :parent, :rank

    def initialize parent, rank=1
      @parent = parent
      @rank = rank
    end
  end

  def initialize size
    @nodes = Array.new(size)
    @sizes = Array.new(size)
    (0...size).each do |i|
      @nodes[i] = Node.new(i)
      @sizes[i] = 1
    end
  end

  def unite a, b
    a = root(a)
    b = root(b)

    return false if a == b

    if @nodes[a].rank < @nodes[b].rank
      @sizes[@nodes[a].parent] += @sizes[@nodes[b].parent]
      @nodes[b].parent = @nodes[a].parent
    else
      @sizes[@nodes[b].parent] += @sizes[@nodes[a].parent]
      @nodes[a].parent = @nodes[b].parent
      @nodes[a].rank += 1 if @nodes[a].rank == @nodes[b].rank
    end

    true
  end

  def same? a, b
    root(a) == root(b)
  end

  def size i
    @sizes[root(i)]
  end

  private

  def root i
    if @nodes[i].parent == i
      i
    else
      @nodes[i].parent = root(@nodes[i].parent)
    end
  end
end